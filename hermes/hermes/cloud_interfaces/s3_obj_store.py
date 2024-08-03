import os
import base64
import boto3
import hashlib
from jproperties import Properties
from botocore.exceptions import ClientError
from functools import lru_cache
from typing import Iterator, List, Optional, Tuple

from hermes import exceptions
from hermes.cloud_interfaces.object_store import ObjectStore, BlobObject

class S3Object(BlobObject):
    def full_path(self):
        return f"s3://{self.bucket}/{self.key}"


class S3ObjectStore(ObjectStore):
    def __init__(self, bucket_name: str):
        self.requester_pays = False
        self.bucket_name = bucket_name
        self._cached_s3_clients = {}
        config = Properties()
        home = os.path.expanduser("~")
        with open(f"{home}/arachne/config/config.properties", "rb") as f:
            config.load(f)
        session = boto3.Session(
                aws_access_key_id=config.get('access_key_id').data, 
                aws_secret_access_key=config.get('secret_access_key').data
        )
        self._s3_client = session.client("s3")

    def path(self):
        return f"s3://{self.bucket_name}"

    def bucket(self) -> str:
        return self.bucket_name

    def bucket_exists(self):
        try:
            requester_pays = {"RequestPayer": "requester"} if self.requester_pays else {}
            self._s3_client.list_objects_v2(Bucket=self.bucket_name, MaxKeys=1, **requester_pays)
            return True
        except ClientError as e:
            if e.response["Error"]["Code"] == "NoSuchBucket" or e.response["Error"]["Code"] == "AccessDenied":
                return False
            raise

    def create_bucket(self, aws_region):
        if not self.bucket_exists():
            if aws_region == "us-east-1":
                self._s3_client.create_bucket(Bucket=self.bucket_name)
            else:
                self._s3_client.create_bucket(Bucket=self.bucket_name, CreateBucketConfiguration={"LocationConstraint": aws_region})

    def delete_bucket(self):
        self._s3_client().delete_bucket(Bucket=self.bucket_name)

    def list_multipart_uploads(self):
        response = self._s3_client.list_multipart_uploads(Bucket=self.bucket_name)
        return response

    def abort_multipart_upload(self, key, upload_id):
        response = self._s3_client.abort_multipart_upload(
                Bucket=self.bucket_name,
                Key=key,
                UploadId=upload_id)
        return response


    def list_objects(self, prefix="") -> Iterator[S3Object]:
        paginator = self._s3_client.get_paginator("list_objects_v2")
        requester_pays = {"RequestPayer": "requester"} if self.requester_pays else {}
        page_iterator = paginator.paginate(Bucket=self.bucket_name, Prefix=prefix, **requester_pays)
        for page in page_iterator:
            objs = []
            for obj in page.get("Contents", []):
                objs.append(
                    S3Object("aws", self.bucket_name, obj["Key"], obj["Size"], obj["LastModified"], mime_type=obj.get("ContentType"))
                )
            yield from objs

    def delete_objects(self, keys: List[str]):
        while keys:
            batch, keys = keys[:1000], keys[1000:]  # take up to 1000 keys at a time
            self._s3_client.delete_objects(Bucket=self.bucket_name, Delete={"Objects": [{"Key": k} for k in batch]})

    @lru_cache(maxsize=1024)
    def get_obj_metadata(self, obj_name):
        try:
            return self._s3_client.head_object(Bucket=self.bucket_name, Key=str(obj_name))
        except ClientError as e:
            raise NoSuchObjectException(f"Object {obj_name} does not exist, or you do not have permission to access it") from e

    def get_obj_size(self, obj_name):
        return self.get_obj_metadata(obj_name)["ContentLength"]

    def get_obj_last_modified(self, obj_name):
        return self.get_obj_metadata(obj_name)["LastModified"]

    def get_obj_mime_type(self, obj_name):
        return self.get_obj_metadata(obj_name)["ContentType"]

    def exists(self, obj_name):
        try:
            self.get_obj_metadata(obj_name)
            return True
        except NoSuchObjectException:
            return False

    def download_object(
        self,
        src_object_name,
        dst_file_path,
        offset_bytes=None,
        size_bytes=None,
        write_at_offset=False,
        generate_md5=False,
        write_block_size=2**16,
    ) -> Tuple[Optional[str], Optional[bytes]]:

        src_object_name, dst_file_path = str(src_object_name), str(dst_file_path)
        s3_client = self._s3_client
        assert len(src_object_name) > 0, f"Source object name must be non-empty: '{src_object_name}'"
        args = {"Bucket": self.bucket_name, "Key": src_object_name}
        assert not (offset_bytes and not size_bytes), f"Cannot specify {offset_bytes} without {size_bytes}"
        if offset_bytes is not None and size_bytes is not None:
            args["Range"] = f"bytes={offset_bytes}-{offset_bytes + size_bytes - 1}"
        if self.requester_pays:
            args["RequestPayer"] = "requester"
        response = s3_client.get_object(**args)

        # write response data
        if not os.path.exists(dst_file_path):
            open(dst_file_path, "a").close()
        if generate_md5:
            m = hashlib.md5()
        with open(dst_file_path, "wb+" if write_at_offset else "wb") as f:
            f.seek(offset_bytes if write_at_offset else 0)
            b = response["Body"].read(write_block_size)
            while b:
                if generate_md5:
                    m.update(b)
                f.write(b)
                b = response["Body"].read(write_block_size)
        response["Body"].close()
        md5 = m.digest() if generate_md5 else None
        mime_type = response["ContentType"]
        return mime_type, md5

    def upload_object(
        self, src_file_path, dst_object_name, part_number=None, upload_id=None, check_md5=None, mime_type=None
    ):
        dst_object_name, src_file_path = str(dst_object_name), str(src_file_path)
        s3_client = self._s3_client
        assert len(dst_object_name) > 0, f"Destination object name must be non-empty: '{dst_object_name}'"
        b64_md5sum = base64.b64encode(check_md5).decode("utf-8") if check_md5 else None
        checksum_args = dict(ContentMD5=b64_md5sum) if b64_md5sum else dict()

        try:
            with open(src_file_path, "rb") as f:
                if upload_id:
                    s3_client.upload_part(
                        Body=f,
                        Key=dst_object_name,
                        Bucket=self.bucket_name,
                        PartNumber=part_number,
                        UploadId=upload_id.strip(),  # TODO: figure out why whitespace gets added,
                        **checksum_args,
                    )
                else:
                    mime_args = dict(ContentType=mime_type) if mime_type else dict()
                    s3_client.put_object(Body=f, Key=dst_object_name, Bucket=self.bucket_name, **checksum_args, **mime_args)
        except ClientError as e:
            # catch MD5 mismatch error and raise appropriate exception
            if "Error" in e.response and "Code" in e.response["Error"] and e.response["Error"]["Code"] == "InvalidDigest":
                raise exceptions.ChecksumMismatchException(f"Checksum mismatch for object {dst_object_name}") from e
            raise

    def initiate_multipart_upload(self, dst_object_name: str, mime_type: Optional[str] = None) -> str:
        client = self._s3_client
        assert len(dst_object_name) > 0, f"Destination object name must be non-empty: '{dst_object_name}'"
        response = client.create_multipart_upload(
            Bucket=self.bucket_name, Key=dst_object_name, **(dict(ContentType=mime_type) if mime_type else dict())
        )
        if "UploadId" in response:
            return response["UploadId"]
        else:
            raise exceptions.HermesException(f"Failed to initiate multipart upload for {dst_object_name}: {response}")

    def complete_multipart_upload(self, dst_object_name, upload_id):
        s3_client = self._s3_client
        all_parts = []
        while True:
            response = s3_client.list_parts(
                Bucket=self.bucket_name, Key=dst_object_name, MaxParts=100, UploadId=upload_id, PartNumberMarker=len(all_parts)
            )
            if "Parts" not in response:
                break
            else:
                if len(response["Parts"]) == 0:
                    break
                all_parts += response["Parts"]
        all_parts = sorted(all_parts, key=lambda d: d["PartNumber"])
        response = s3_client.complete_multipart_upload(
            UploadId=upload_id,
            Bucket=self.bucket_name,
            Key=dst_object_name,
            MultipartUpload={"Parts": [{"PartNumber": p["PartNumber"], "ETag": p["ETag"]} for p in all_parts]},
        )
        assert "ETag" in response, f"Failed to complete multipart upload for {dst_object_name}: {response}"

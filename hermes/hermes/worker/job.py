import os
from dataclasses import dataclass
from typing import Optional
from hermes.exceptions import HermesException

@dataclass
class Job:
    provider: str
    src_bucket: str
    dst_bucket: str
    src_path: str
    dst_path: str
    tmp_file: str
    job_type: Optional[str] = None
    part_number: Optional[int] = None
    upload_id: Optional[int] = None

    def src_full_path(self):
        pre = None
        if self.provider == "gcp":
            pre = "gs"
        elif self.provider == "aws":
            pre = "s3"
        else:
            raise HermesException("Invalid provider type")
        return os.path.join(f"{pre}://{self.src_bucket}", self.src_path)

    def dst_full_path(self):
        pre = None
        if self.provider == "gcp":
            pre = "gs"
        elif self.provider == "aws":
            pre = "s3"
        else:
            raise HermesException("Invalid provider type")
        return os.path.join(f"{pre}://{self.dst_bucket}", self.dst_path)

@dataclass
class UploadJob(Job):
    job_type: Optional[str] = "upload"
    md5: Optional[bytes] = None
    mime_type: Optional[str] = None

@dataclass
class DownloadJob(Job):
    job_type: Optional[str] = "download"
    offset: Optional[int] = None
    size: Optional[int] = None
    generate_md5: bool = False


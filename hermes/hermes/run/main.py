from argparse import ArgumentParser
import time
import os
import math

from hermes.cloud_interfaces.object_store import ObjectStore
from hermes.cloud_interfaces.gcp_obj_store import GCPObjectStore
from hermes.worker import UploadJob, DownloadJob, WorkerPool
from hermes.run.dispatcher import do_parallel, initiate_multipart_upload, complete_multipart_upload
from hermes.constants import chunk_size_mb, max_num_chunks, MB
from hermes.exceptions import HermesException

def parse_recursive(key: str) -> str:
    vals = key.split("/")
    vals = [v for v in vals if v != ""]
    bucket = vals[1]
    folder = "/".join(vals[2:])
    return bucket, folder

def parse(key: str) -> str:
    vals = key.split("/")
    vals = [v for v in vals if v != ""]
    bucket = vals[1]
    obj = vals[-1]
    prefix = "/".join(vals[2:-1])
    return bucket, prefix, obj

def cleanup():
    aws = ObjectStore.create("aws", "arachne-transfer")
    response = aws.list_multipart_uploads()
    if "Uploads" not in response:
        print("No multipart uploads to abort")
        return 

    for d in response["Uploads"]:
        r = aws.abort_multipart_upload(d['Key'], d['UploadId'])
        print(r)
        print(f"Aborted {d['Key']}, {d['UploadId']}")

def run():
    parser = ArgumentParser(description="Run transfer between GCP and AWS")
    parser.add_argument("-r", "--recursive", action="store_true", help="Copy directory recursively")
    parser.add_argument("cmd", choices=['cp', 'clean'], help="Command to execute")
    parser.add_argument("srcs", type=str, nargs='+', help="Source files")
    parser.add_argument("dst", type=str, nargs=1, help="Destination bucket")
    args = parser.parse_args()

    print(args.cmd)
    print(args.srcs)
    print(args.dst)
    if args.cmd == "clean":
        cleanup()
        return

    try: 
        dst_bucket, _, _ = parse(args.dst[0])
        arg_list: List[List[str]] = []
        if args.recursive:
            for s in args.srcs:
                src_bucket, src_folder = parse_recursive(s)
                gcp = ObjectStore.create("gcp", src_bucket)
                for obj in gcp.list_objects(src_folder):
                    if obj.key[-1] == '/': # ignore directory names
                        continue
                    names = obj.key.split("/") 
                    src_obj = names[1]
                    vals = [src_folder, src_obj, src_bucket, dst_bucket, src_obj]
                    arg_list.append(vals)

        else:
            for s in args.srcs:
                src_bucket, src_prefix, src_obj = parse(s)
                vals = [src_prefix, src_obj, src_bucket, dst_bucket, src_obj]
                arg_list.append(vals)

        
        for foo in arg_list:
            print(foo)
        # print(arg_list)
        # create initiate multipart upload job
        # dispatch initiate requests in parallel
        upload_ids = do_parallel(initiate_multipart_upload, arg_list, n=-1)
        print('hi')

        # create download job with upload info
        complete_upload_arg_list: List[List[str]] = []
        download_jobs = []
        for args, upload_id in upload_ids:
            assert len(args) == 5, f"Incorrect number of arguments to initiate function"
            src_prefix, src, src_bucket, dst_bucket, dst = args
            full_src_path = os.path.join(src_prefix, src)

            complete_vals = [dst_bucket, dst, upload_id]
            complete_upload_arg_list.append(complete_vals)
            
            gcp = ObjectStore.create("gcp", src_bucket)
            size = gcp.get_obj_size(full_src_path)
            chunk_size_bytes = int(chunk_size_mb * MB)
            num_parts = math.ceil(size / chunk_size_bytes)

            if num_parts > max_num_chunks:
                chunk_size_bytes = int(size / max_num_chunks)
                chunk_size_bytes = math.ceil(chunk_size_bytes / MB) * MB  # round to next largest mb
                num_parts = math.ceil(size / chunk_size_bytes)

            offset: int = 0
            part_num = 1
            print(num_parts)
            for i in range(num_parts):
                part_size = min(chunk_size_bytes, size - offset)
                tmp_file = f"/mnt/disks/tpcds/tmp/{src}_{part_num}"
                job = DownloadJob(
                   provider="gcp",
                   src_bucket=src_bucket,
                   dst_bucket=dst_bucket,
                   src_path=full_src_path,
                   dst_path=dst,
                   tmp_file=tmp_file,
                   job_type="download",
                   part_number=part_num,
                   upload_id=upload_id,
                   offset=offset,
                   size=part_size,
                   generate_md5=True
                )
                download_jobs.append(job)
                offset += chunk_size_bytes
                part_num += 1

        # create worker pool
        total_jobs = 2 * len(download_jobs)
        # total_jobs = len(download_jobs)
        pool = WorkerPool(32)
        # add download jobs to worker pool
        for job in download_jobs:
            pool.add_download_job(job)
        pool.start_workers()
        # wait till 2 * number of dispatched download jobs are completed (1 up for
        # every download job)
        while True:
            with pool.lock:
                if pool.completed_jobs.value >= total_jobs:
                    break
            time.sleep(1)

        pool.stop_workers()

        # dispatch complete requests in parallel
        do_parallel(complete_multipart_upload, complete_upload_arg_list, n=-1)
        print("Completed transfer")
        # # print(args.cmd)
        # # gos = ObjectStore.create("gcp", "arachne_tpcds_1tb")
        # s3 = ObjectStore.create("aws", "arachne-transfer")
        # objs = s3.list_objects()
        # for o in objs:
        #     print(o.key)

        # objs = gos.list_objects()
        # for o in objs:
        #     print(o.key)
    except Exception as e:
        # want to abort all the initiated multipart uploads 
        cleanup()
        raise e











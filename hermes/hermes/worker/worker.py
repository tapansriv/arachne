import queue 
import os
import time
from multiprocessing import Event, Manager, Process, Value, Queue

from hermes.cloud_interfaces import ObjectStore, GCPObjectStore, S3ObjectStore
from hermes.cloud_interfaces import BlobObject, GCPObject, S3Object
from hermes.exceptions import HermesException
from .job import UploadJob, DownloadJob

class WorkerPool:
    def __init__(self, n_processes=24): 
        self.n_processes: int = n_processes # look at this maybe
        self.processes: List[Process] = []

        #shared state
        self.manager = Manager()
        self._upload_queue: queue.Queue[UploadJob] = self.manager.Queue()
        self._download_queue: queue.Queue[DownloadJob] = self.manager.Queue()
        self.exit_flags = [Event() for _ in range(self.n_processes)]
        self.lock = self.manager.Lock()
        self.completed_jobs = self.manager.Value("i", 0)

        self.worker_id: Optional[int] = None

    def start_workers(self):
        for i in range(self.n_processes):
            p = Process(target=self.run, args=(i,))
            p.start()
            self.processes.append(p)

    def stop_workers(self):
        for i in range(self.n_processes):
            self.exit_flags[i].set()
        for p in self.processes:
            p.join()
        self.processes = []

    def add_upload_job(self, job: UploadJob):
        self._upload_queue.put(job)

    def add_download_job(self, job: DownloadJob):
        self._download_queue.put(job)

    def run(self, worker_id: int):
        self.worker_id = worker_id

        while not self.exit_flags[worker_id].is_set():
            try:
                try:
                    job: UploadJob = self._upload_queue.get_nowait()
                except queue.Empty: 
                    try:
                        job: DownloadJob = self._download_queue.get_nowait()
                    except queue.Empty:
                        continue
                if job.job_type == "upload":
                    s3_obj_store = ObjectStore.create("aws", job.dst_bucket)

                    # dst = job.dst_path()
                    s3_obj_store.upload_object(
                            job.tmp_file,
                            job.dst_path,
                            part_number=job.part_number,
                            upload_id=job.upload_id,
                            check_md5=job.md5,
                            mime_type=job.mime_type)

                    with self.lock:
                        self.completed_jobs.value += 1

                elif job.job_type == "download":
                    gcp_obj_store = ObjectStore.create("gcp", job.src_bucket)
                    # print(f"Downloading {job.src_full_path()} to {job.tmp_file}")
                    mime_type, md5 = gcp_obj_store.download_object(
                            job.src_path,
                            job.tmp_file,
                            offset_bytes=job.offset,
                            size_bytes=job.size,
                            write_at_offset=False,
                            generate_md5=job.generate_md5)
                    # print(f"Downloaded {job.src_full_path()} to {job.tmp_file}")
                    # print(f"Creating upload job: {job.tmp_file} to s3://arachne-transfer/{job.dst_path}")
                    upload_job = UploadJob(
                            provider="aws",
                            src_bucket=job.src_bucket,
                            dst_bucket=job.dst_bucket,
                            src_path=job.src_path, 
                            dst_path=job.dst_path,
                            tmp_file=job.tmp_file,
                            job_type="upload",
                            part_number=job.part_number,
                            upload_id=job.upload_id,
                            md5=md5,
                            mime_type=mime_type) 
                    self.add_upload_job(upload_job)
                    with self.lock:
                        self.completed_jobs.value += 1
                else:
                    raise ValueError("Invalid job type")

            except Exception as e:
                raise HermesException("rip you") from e



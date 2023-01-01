import time
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Callable, Iterable, List, Optional, Tuple, Union, TypeVar

from hermes.cloud_interfaces import ObjectStore

T = TypeVar("T")
R = TypeVar("R")

def do_parallel(
    func: Callable[[T], R], args_list: Iterable[T], n=-1, return_args=True) -> List[Union[Tuple[T, R], R]]:

    args_list = list(args_list)
    if len(args_list) == 0:
        return []

    if n == -1:
        n = len(args_list)

    def wrapped_fn(args):
        try:
            return args, func(args)
        except Exception as e:
            print(f"Error running {func.__name__}: {e}")
            raise

    results = []
    with ThreadPoolExecutor(max_workers=n) as executor:
        future_list = [executor.submit(wrapped_fn, args) for args in args_list]
        for future in as_completed(future_list):
            args, result = future.result()
            results.append((args, result))

    return results if return_args else [result for _, result in results]


def initiate_multipart_upload(args):
    src_prefix, src, src_bucket, dst_bucket, dst = args
    print(src_prefix)
    print(src)
    gcp = ObjectStore.create("gcp", src_bucket)
    aws = ObjectStore.create("aws", dst_bucket)
    src_obj = os.path.join(src_prefix, src)
    mime_type = gcp.get_obj_mime_type(src_obj)
    upload_id = aws.initiate_multipart_upload(dst, mime_type=mime_type)
    return upload_id

def complete_multipart_upload(args):
    dst_bucket, dst, upload_id = args
    aws = ObjectStore.create("aws", dst_bucket)
    aws.complete_multipart_upload(dst, upload_id)

import os
import sys
import time
import json
import boto3
from argparse import ArgumentParser

class AbortedException(Exception):
    pass

class FailedException(Exception):
    pass

def pause_cluster(cluster_id):
    client = boto3.client('redshift')
    response = client.pause_cluster(
        ClusterIdentifier=cluster_id,
    )
    print(response)

def run_one_query(cid, user, qry):
    client = boto3.client('redshift-data')

    print(f"querying against {cid}")
    disable_query_cache = "SET enable_result_cache_for_session TO OFF"
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = disable_query_cache
    )
    jobId = response['Id']
    while True:
        time.sleep(0.01)
        response = client.describe_statement(Id=jobId)
        if response['Status'] == "FINISHED":
            break
        elif response['Status'] in ["ABORTED", "FAILED"]:
            print(response)
            raise ValueError()


    print(f"starting query")
    done = False
    start = time.time()
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = qry
    )
    jobId = response['Id']

    while not done:
        time.sleep(0.5)
        response = client.describe_statement(
                    Id=jobId
        )
        if response['Status'] == "FINISHED":
            response = client.get_statement_result(Id=jobId)
            total_records = 0
            records = []
            while True:
                total_records += len(response['Records'])
                for r in response['Records']:
                    records.append(r)
                if 'NextToken' in response:
                    response = client.get_statement_result(Id=jobId)
                else:
                    break

            end = time.time()
            runtime = end - start
            print(f"Query runtime: {runtime} seconds")
            assert len(records) == total_records, "Didn't consume all records for"
            return runtime

        elif response['Status'] == "ABORTED":
            print(f"query aborted")
            raise AbortedException()
            
        elif response['Status'] == "FAILED":
            print(f"query failed to run")
            print(response)
            raise FailedException()

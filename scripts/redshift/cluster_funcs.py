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

def run_explain(cid, user, qid, qry):
    client = boto3.client('redshift-data')
    qry2 = f"EXPLAIN {qry}"

    print(f"running explain for {qid} against {cid}")
    done = False
    start = time.time()
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = qry2
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
                    for x in r:
                        records.append(x['stringValue'])
                if 'NextToken' in response:
                    response = client.get_statement_result(Id=jobId,
                                                           NextToken=response['NextToken'])
                    print('looping')
                else:
                    break

            assert len(records) == total_records, "Didn't consume all records"
            plan = "\n".join(records)
            with open(f"{qid}.plan", 'w') as fp:
                fp.write(plan)
            return

        elif response['Status'] == "ABORTED":
            print(f"query aborted")
            print(response)
            raise AbortedException()
            
        elif response['Status'] == "FAILED":
            print(f"query failed to run")
            print(response)
            raise FailedException()

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
            read_start = time.time()
            response = client.get_statement_result(Id=jobId)
            total_records = 0
            records = []
            while True:
                total_records += len(response['Records'])
                for r in response['Records']:
                    records.append(r)
                if 'NextToken' in response:
                    response = client.get_statement_result(Id=jobId,
                                                           NextToken=response['NextToken'])
                    print('looping')
                else:
                    break

            end = time.time()
            runtime = end - start
            readTime = end - read_start
            print(f"Query runtime: {runtime} seconds")
            print(f"SPENT {readTime} seconds reading results")
            assert len(records) == total_records, "Didn't consume all records"
            return runtime

        elif response['Status'] == "ABORTED":
            print(f"query aborted")
            print(response)
            raise AbortedException()
            
        elif response['Status'] == "FAILED":
            print(f"query failed to run")
            print(response)
            raise FailedException()

if __name__ == '__main__':
    parser = ArgumentParser(description="Load tables into Redshift")
    parser.add_argument("--cid", help="Name of cluster")
    parser.add_argument("command", choices=["pause"], help="what command to run")
    args = parser.parse_args()

    if args.command == "pause":
        pause_cluster(args.cid)
    else:
        raise ValueError("Invalid Argument")




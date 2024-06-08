'''
Checks between variants of same type to make sure there isn't overlap

Checks between queries used in test set (arachneDB/a_queries) to make sure there
isn't overlap between test and training sets
'''
from argparse import ArgumentParser
from typing import List
import os
import glob
import shutil

def move_duplicates(duplicates: List[str], train_dir: str, dest: str):
    try:
        for d in duplicates:
            f = os.path.join(train_dir, d)
            shutil.move(f, dest)
    except:
        print("Ooopsie Daisy Baby Grl")
        raise


'''
removes all whitespace and newlines, trailing semicolon in query string and
makes lower case so queries in different visual styles can be compared
automatically
'''
def normalize_query_string(query_str: str) -> str:
    query_lower = query_str.lower()
    query_whitespace_lower = ''.join(query_lower.split())
    if query_whitespace_lower[-1] == ';':
        query_whitespace_lower = query_whitespace_lower[:-1]
    return query_whitespace_lower


def compare_two_query_files(filename1: str, filename2: str) -> bool:
    f1 = open(filename1)
    query1 = f1.read()
    f1.close()

    f2 = open(filename2)
    query2 = f2.read()
    f2.close()

    cleaned1 = normalize_query_string(query1)
    cleaned2 = normalize_query_string(query2)
    
    if cleaned1 == cleaned2:
        print(f"Two files contain the same exact query: {filename1} and {filename2}")
        return True
    return False


'''
Check if overlap within train set between all pairs of training points
THOROUGH
'''
def get_new_queries(orig_dir, new_dir) -> List[str]:
    all_names = []
    for q in glob.glob(f"{orig_dir}/*.sql"):
        key = q.split("/")[-1]
        all_names.append(key)

    n = len(all_names)
    print(n)
    overlaps = 0

    duplicates = []
    for q in all_names:
        filename1 = os.path.join(orig_dir, q)
        for q2 in glob.glob(f"{new_dir}/*.sql"):
            filename2 = os.path.join(new_dir, q2)
            if (not os.path.exists(filename1)) or (not os.path.exists(filename2)):
                continue
            if compare_two_query_files(filename1, filename2):
                duplicates.append(filename2)
                overlaps += 1
    print(f"There were {overlaps} duplicates within the training set compare all")
    return duplicates

if __name__ == '__main__':
    orig_dir = "../train_queries"
    new_dir = "../train_queries_v2"

    duplicates = get_new_queries(orig_dir, new_dir)
    dest = os.path.join(new_dir, "v1")
    move_duplicates(duplicates, new_dir, dest)






    














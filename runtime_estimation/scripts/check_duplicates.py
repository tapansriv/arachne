'''
Checks between variants of same type to make sure there isn't overlap

Checks between queries used in test set (arachneDB/a_queries) to make sure there
isn't overlap between test and training sets
'''
from argparse import ArgumentParser
from typing import List
import os
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
Check if overlap within train set but only within a single template 
WILL MISS SOME DUPLICATES EMPIRICALLY
'''
def check_train_set(num_qs, num_vs, train_dir) -> List[str]:
    overlaps = 0
    duplicates = []
    for q in range(1, num_qs+1):
        key = str(q)
        if q < 10:
            key = f"0{q}"
        for i in range(1, num_vs+1):
            filename1 = os.path.join(train_dir, f"query{key}_{i}.sql")
            for j in range(i+1, num_vs+1):
                filename2 = os.path.join(train_dir, f"query{key}_{j}.sql")
                duplicates.append(filename2)
                if compare_two_query_files(filename1, filename2):
                    overlaps += 1
    print(f"There were {overlaps} duplicates within the training set")
    return duplicates

'''
Check if overlap within train set between all pairs of training points
THOROUGH
'''
def check_train_set_all(num_qs, num_vs, train_dir) -> List[str]:
    all_names = []
    for q in range(1, num_qs+1):
        key = str(q)
        if q < 10:
            key = f"0{q}"
        for v in range(1, num_vs+1):
            all_names.append(f"query{key}_{v}.sql")

    n = len(all_names)
    print(n)
    overlaps = 0

    duplicates = []
    for i in range(n-1):
        filename1 = os.path.join(train_dir, all_names[i])
        if not os.path.exists(filename1):
            continue
        for j in range(i+1, n):
            filename2 = os.path.join(train_dir, all_names[j])
            if not os.path.exists(filename2):
                continue
            if compare_two_query_files(filename1, filename2):
                duplicates.append(filename2)
                if int(i/num_vs) != int(j/num_vs):
                    print(f"Across templates: {filename1}, {filename2}")
                overlaps += 1
    print(f"There were {overlaps} duplicates within the training set compare all")
    return duplicates

'''
Check if overlap between test and train
'''
def check_test_train(num_qs, num_vs, train_dir, test_files) -> List[str]:
    overlaps = 0

    duplicates = []
    for tf in test_files:
        for q in range(1, num_qs+1):
            key = str(q)
            if q < 10:
                key = f"0{q}"
            for i in range(1, num_vs+1):
                train = os.path.join(train_dir, f"query{key}_{i}.sql")
                if os.path.exists(train):
                    if compare_two_query_files(tf, train):
                        duplicates.append(train)
                        overlaps += 1
    print(f"There were {overlaps} duplicates between test and training sets")
    return duplicates

if __name__ == '__main__':
    parser = ArgumentParser(description="Run inter-query analysis")
    parser.add_argument("--num-queries", type=int, default=103, help="Number of queries in train set")
    parser.add_argument("--num-variants", type=int, default=10, 
                        help="Number of query variants in train set")
    parser.add_argument("--train-dir", type=str, default="../queries", 
                        help="Directory where train files are stored")
    parser.add_argument("--test-dir", type=str, default="../../a_queries", 
                        help="Directory where test files are stored")
    parser.add_argument("--test-set", type=str, default=None, 
                        help="File with newline separated list of query file names to use in test set (stored within TEST-DIR")
    args = parser.parse_args()



    test_files = []
    if args.test_set:
        test_files = [os.path.join(args.test_dir, x.strip()) for x in open(args.test_set).readlines()]
    else:
        for i in range(1, 100):
            key = f"{i}.sql"
            if i < 10:
                key = f"0{i}.sql"
            test_files.append(os.path.join(args.test_dir, key))
    
    duplicates_train = check_train_set_all(num_qs=args.num_queries, num_vs=args.num_variants,
                    train_dir=args.train_dir)

    duplicates_test = check_test_train(num_qs=args.num_queries, num_vs=args.num_variants,
                    train_dir=args.train_dir, test_files=test_files)

        
    duplicates = list(set(duplicates_train + duplicates_test))

    dest = os.path.join(args.train_dir, "duplicates")
    move_duplicates(duplicates, args.train_dir, dest)






    














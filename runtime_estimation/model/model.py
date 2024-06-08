'''
train KNearestNeighbors model
'''

from sklearn.neighbors import KNeighborsRegressor
from sklearn.cross_decomposition import CCA
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import normalize
from sklearn.kernel_ridge import KernelRidge
from sklearn.gaussian_process.kernels import RBF
from sklearn.metrics.pairwise import rbf_kernel

from scipy import stats
from scipy.linalg import eig
import numpy as np
from itertools import combinations

import json
import time
import os
import pickle
from argparse import ArgumentParser
from typing import List, Dict, Tuple


# SOURCES FOR POSSIBLE RS OPS (SPECIFIC TO REDSHIFT):
# https://docs.aws.amazon.com/redshift/latest/dg/r_EXPLAIN.html
# https://docs.aws.amazon.com/redshift/latest/dg/c-the-query-plan.html
operators: List[str] = ["Unique", "Limit", "Window", "Result", "Network",
                        "Subquery", "Hash", "Append", "Hash Intersect", 
                        "SetOp Except", "Sort", "Merge", "Aggregate", "Join",
                        "Scan", "Materialize", "Recursive Union"]

# Because Hash substring of Hash Join, HashAggregate, etc.
# So this is unique search str for that; this is also less code to integrate 
# And modular should there be other substring-operator conflicts that show up
def search_line(op: str, line: str) -> bool:
    if op == "Hash":
        check_str = "Hash  ("
        return check_str in line
    elif op == "Scan": 
        return (("Seq Scan" in line) or ("Multi Scan" in line) or ("CTE Scan" in line))
    elif op == "Join":
        return ((op in line) or ("Nested Loop" in line))
    elif op == "Merge":
        return (op in line and "Merge Join" not in line)
    else:
        return op in line


def parse_plan(plan_file: str) -> List[int]:
    f = open(plan_file)
    lines = f.readlines()
    f.close()
    
    plan_stats = {op: {"cnt": 0, "card": 0} for op in operators}
    for line in lines:
        if "rows" not in line:
            continue
        seen = None
        for op in operators:
            if search_line(op, line):
                assert seen is None, f"{plan_file}: {line} has two ops in it"
                seen = op
        assert seen is not None, f"{plan_file}: {line} has op not listed"
        num_rows = int(line.split("rows=")[1].split(" ")[0])
        plan_stats[seen]["cnt"] += 1
        plan_stats[seen]["card"] += num_rows

    train_features: List[int] = []
    for op in operators:
        train_features.append(plan_stats[op]['cnt'])
        train_features.append(plan_stats[op]['card'])
    return train_features

def generate_features_and_labels(query_runtimes: Dict[str, float], plan_dir: str): 
    features = []
    labels = []
    keys = []
    for key in query_runtimes:
        plan_file = os.path.join(plan_dir, f"{key}.plan")
        key_features = parse_plan(plan_file)
        runtime = query_runtimes[key]

        # both must be done together to ensure order is correct
        keys.append(key)
        features.append(key_features)
        labels.append(runtime)
    
    X = np.array(features)
    y = np.array(labels)
    # print(normalize(X, axis=0, norm="l2"))
    return X, y, keys

def kcca_predictions(test_runtimes, test_dir, X_train, y_train):
    start = time.time()
    K_x, K_y = train_kcca(X_train, y_train)
    end = time.time() - start
    print(f"Make kernel matrix {end}")

    Z = np.zeros((n_samples, n_samples))
    top_right = K_x @ K_y
    bottom_left = K_y @ K_x
    left_block = np.block([[Z, top_right], [bottom_left, Z]])
    print(left_block.shape)

    top_left = K_x @ K_x
    bottom_right = K_y @ K_y
    right_block = np.block([[top_left, Z], [Z, bottom_right]])
    print(right_block.shape)
    assert left_block.shape == right_block.shape

    start = time.time()
    w, vr = eig(left_block, right_block)
    end = time.time() - start
    print(f"Eig: {end} seconds")

    print(vr.shape)
    A = vr[:n_samples,] 
    B = vr[n_samples:,] 

    X_test, y_test, keys = generate_features_and_labels(test_runtimes, test_dir)
    X_test =  normalize(X_test, axis=1)
    print(stats.describe(y_test))
    
    K_x_test = make_test_kcca(X_train, X_test)
    projected_X_test = K_x_test @ A
    print(projected_X_test.shape)

    projected_X_train = K_x @ A
    model = KNeighborsRegressor(n_neighbors=5, weights='uniform')
    model.fit(projected_X_train, y_train)

    train_preds = model.predict(projected_X_train)
    train_errors = abs(train_preds - y_train)
    print(f"Mean Absolute Training Error: {round(np.mean(train_errors), 2)} seconds")

    predictions = model.predict(projected_X_test)
    output = {}
    diffs = []
    for i in range(len(predictions)):
        output[keys[i]] = predictions[i]
        d = abs(predictions[i] - y_test[i]) / y_test[i]
        # print(f"{keys[i]}: {y_test[i]}, {predictions[i]}, {d}")
        diffs.append(d)

    diffs.sort()
    i_20, i_30 = 0,0
    for i in range(len(diffs)):
        if diffs[i] < 0.2:
            i_20 = i+1
        if diffs[i] < 0.3:
            i_30 = i+1

    i = int(0.8 * len(diffs))
    print(f"{i_20}, {i_30}, {i+1}, {len(diffs)}")
    print(diffs[:i])

    test_errors = abs(predictions - y_test)
    print(f"Mean Absolute Error: {round(np.mean(test_errors), 2)} seconds")

    score = model.score(projected_X_test, y_test)
    print(f"R-squared value of {score}") 

    with open("rs_baseline.json", 'w') as fp:
        json.dump(output, fp, indent=4, sort_keys=True)

def make_predictions(model, test_runtimes, test_dir):
    X_test, y_test, keys = generate_features_and_labels(test_runtimes, test_dir)
    print(stats.describe(y_test))

    predictions = model.predict(X_test)
    output = {}
    diffs = []
    for i in range(len(predictions)):
        output[keys[i]] = predictions[i]
        d = abs(predictions[i] - y_test[i]) / y_test[i]
        # print(f"{keys[i]}: {y_test[i]}, {predictions[i]}, {d}")
        diffs.append(d)

    diffs.sort()
    i_20, i_30 = 0,0
    for i in range(len(diffs)):
        if diffs[i] < 0.2:
            i_20 = i+1
        if diffs[i] < 0.3:
            i_30 = i+1

    i = int(0.8 * len(diffs))
    print(f"{i_20}, {i_30}, {i+1}, {len(diffs)}")
    print(diffs[:i])

    test_errors = abs(predictions - y_test)
    print(f"Mean Absolute Error: {round(np.mean(test_errors), 2)} seconds")

    score = model.score(X_test, y_test)
    print(f"R-squared value of {score}") 

    with open("rs_baseline.json", 'w') as fp:
        json.dump(output, fp, indent=4, sort_keys=True)

def clean_dict_keys(fname: str) -> Dict:
    try:
        f = open(fname)
        raw = json.load(f)
        f.close()

        # remove leading path shit from keys
        ret = {}
        for k in raw:
            new_k = k
            if "/" in new_k: 
                new_k = new_k.split("/")[-1]
            if new_k.endswith(".sql"):
                new_k = new_k[:-4]
            ret[new_k] = raw[k]
        return ret
    except: 
        print("Loading file failed; ensure they are proper JSON files")
        raise 

def make_test_kcca(X_train, X_test):
        assert X_train.shape[1] == X_test.shape[1], "must be same number of samples in X and y"
        n_train = X_train.shape[0]
        n_test = X_test.shape[0]
        K_x = np.zeros((n_test, n_samples))

        for i in range(n_test):
            for j in range(n_train):
                K_x[i,j] = gaussian_kernel(X_test[i,:], X_train[j,:])
        return K_x

def train_kcca(X, y):
        assert X.shape[0] == y.shape[0], "must be same number of samples in X and y"
        y.reshape((-1,1))
        print(y.shape)
        print(y[1].ravel().shape)
        n_samples = X.shape[0]
        K_x = np.eye(n_samples)
        K_y = np.eye(n_samples)

        for i in range(n_samples):
            for j in range(i):
                K_x[i,j] = gaussian_kernel(X[i,:], X[j,:])
                K_x[j,i] = K_x[i,j]

                K_y[i,j] = gaussian_kernel(y[i].ravel(), y[j].ravel())
                K_y[j,i] = K_y[i,j]

        return K_x, K_y


def gaussian_kernel(X, X2, sigma=1.0):
    """
    Calculate the Gaussian kernel matrix

        k_ij = exp(-||x_i - x_j||^2 / (2 * sigma^2))

    :param X: array-like, shape=(n, ), feature-matrix
    :param X2: array-like, shape=(n,), feature-matrix
    :param sigma: scalar, bandwidth parameter

    :return: array-like, shape=(n_samples_1, n_samples_2), kernel matrix
    """
    assert X.ndim == 1 and X2.ndim == 1
    norm = np.square(np.linalg.norm(X - X2))
    res = np.exp(-norm/(2*np.square(sigma)))
    return res

if __name__ == '__main__':
    parser = ArgumentParser(description="Parse query plans and train KCCA model")
    parser.add_argument("--train-runtimes-file", nargs="*", 
                        default=["../baselines/train_runtimes.json", 
                                 "../baselines/train_runtimes_v2.json",
                                 "../baselines/train_tpcds_sf100.json",
                                 "../baselines/train_tpcds_sf1000.json",
                                 "../baselines/custom_train_sf100.json",
                                 ], 
                        help="Where runtimes are stored as a json file")
    parser.add_argument("--train-plan-dir", nargs="*", 
                        default=["../train_plans", 
                                 "../train_plans_v2",
                                 "../train_tpcds_sf100",
                                 "../train_tpcds_sf1000",
                                 "../rbw_plans_sf100",
                                 ],
                        help="Directory where query plans from Redshift are stored")

    parser.add_argument("--test-runtimes-file", type=str, 
                        default="../baselines/test_runtimes.json", 
                        help="Where runtimes are stored as a json file")

    parser.add_argument("--test-plan-dir", type=str,
                        default="../test_plans",
                        help="Directory where query plans from Redshift are stored")
    parser.add_argument("--refresh", action="store_true", help="Force retrain model")
    args = parser.parse_args()

    print(args.test_runtimes_file)

    model = None
    if os.path.exists('model.sav') and not args.refresh:
        # load the model from disk
        model = pickle.load(open('model.sav', 'rb'))
    else:
        assert len(args.train_plan_dir) == len(args.train_runtimes_file), \
                "Must give same number of train files and plan files"

        Xs, ys = [], []
        for i in range(len(args.train_plan_dir)):
            train_runtimes_i = clean_dict_keys(args.train_runtimes_file[i])
            X_train_i, y_train_i, _ = generate_features_and_labels(train_runtimes_i,
                    args.train_plan_dir[i])
            
            print(X_train_i.shape)
            print(y_train_i.shape)
            Xs.append(X_train_i)
            ys.append(y_train_i)

        X_train = np.vstack(Xs)
        y_train = np.concatenate(ys)
        X_train = normalize(X_train, axis=1)
        # print(X_train[:,-5])

        n_samples, n_features = X_train.shape
        assert n_samples == y_train.shape[0]
        print(X_train.shape)
        print(y_train.shape)

        print(stats.describe(y_train))
        test_runtimes = clean_dict_keys(args.test_runtimes_file)
        kcca_predictions(test_runtimes, args.test_plan_dir, X_train, y_train)
        # make_predictions(model, test_runtimes, args.test_plan_dir)
        
        # start = time.time()
        # K_x, K_y = train_kcca(X_train, y_train)
        # end = time.time() - start
        # print(end)

        # Z = np.zeros((n_samples, n_samples))
        # top_right = K_x @ K_y
        # bottom_left = K_y @ K_x
        # left_block = np.block([[Z, top_right], [bottom_left, Z]])
        # print(A.shape)

        # top_left = K_x @ K_x
        # bottom_right = K_y @ K_y
        # right_block = np.block([[top_left, Z], [Z, bottom_right]])
        # print(B.shape)
        # assert A.shape == B.shape

        # 
        # start = time.time()
        # w, vr = eig(left_block, right_block)
        # end = time.time() - start
        # print(f"Eig: {end} seconds")

        # print(vr.shape)
        # A = vr[:n_samples,] 
        # B = vr[n_samples:,] 

        # projected_X_train = K_x @ A
        # projected_y_train = K_y @ B

        # model = KNeighborsRegressor(n_neighbors=3, weights='uniform')
        # model = RandomForestRegressor()
        # model = KernelRidge(alpha=1.0)
        # model = CCA(n_components=1)
        # model.fit(X_train, y_train)
        # X_c, Y_c = model.transform(X_train, y_train)
        # print(X_c.shape)
        # print(Y_c.shape)
        # print(model.coef_.shape)




        feather, golf, bowling = 0,0,0
        for y in y_train:
            if y < 180:
                feather += 1
            elif y >=180 and y < 1780:
                golf += 1
            else:
                bowling += 1
        print(f"{feather}, {golf}, {bowling}")





        # train_preds = model.predict(X_train)
        # train_errors = abs(train_preds - y_train)
        # print(f"Mean Absolute Training Error: {round(np.mean(train_errors), 2)} seconds")


        # knnPickle = open('model.sav', 'wb')
        # pickle.dump(model, knnPickle)
        # knnPickle.close()

    # print(model)
    # test_runtimes = clean_dict_keys(args.test_runtimes_file)
    # make_predictions(model, test_runtimes, args.test_plan_dir)

        









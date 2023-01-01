import json
import math

BYTES_TO_TB = math.pow(2,40)
SEC_TO_HR = 3600

def rs_sort(args, RS_COST):
    rs = json.load(open("rs_baseline.json"))
    rs_c = json.load(open("rs_c_baseline.json"))
    best_rs = {}
    keys = rs.keys()
    for k in keys:
        if k not in rs_c or rs[k] < rs_c[k]:
            best_rs[k] = rs[k]
        else:
            best_rs[k] = rs_c[k]

    costs = {k: RS_COST * (best_rs[k] / SEC_TO_HR) for k in rs}
    sorted_costs = sorted(costs.items(), key=lambda x: x[1], reverse=True)
    for k, v in sorted_costs:
        print(f"{k}: ${v}")
    

def bq_sort(args, BQ_COST):
    bq = json.load(open("bigquery_baseline.json"))
    costs = {k: BQ_COST * (bq[k]['bytes'] / BYTES_TO_TB) for k in bq}
    sorted_costs = sorted(costs.items(), key=lambda x: x[1], reverse=True)
    for k, v in sorted_costs:
        print(f"{k}: ${v}")
    


def compare(args, BQ_COST, RS_COST):
    bq = json.load(open("bigquery_baseline.json"))
    rs = json.load(open("rs_baseline.json"))
    rs_c = json.load(open("rs_c_baseline.json"))

    best_rs = {}
    keys = rs.keys()#  & rs_c.keys()
    for k in keys:
        if k not in rs_c or rs[k] < rs_c[k]:
            best_rs[k] = rs[k]
        else:
            best_rs[k] = rs_c[k]


    keys = bq.keys() & best_rs.keys()
    print(f"Data path: {args.path}")
    print(f"BigQuery Cost: ${BQ_COST}/TB; Redshift Cost: ${RS_COST}/HR")
    print(f"Num keys: {len(keys)}")

    bq_cheaper = {}
    rs_cheaper = {}
    for k in sorted(keys):
        bq_q_cost = BQ_COST * (bq[k]['bytes'] / BYTES_TO_TB)
        rs_q_cost = RS_COST * (best_rs[k] / SEC_TO_HR)
        if args.verbose:
            print(f"{k}: {bq_q_cost:.2f}:: {rs_q_cost:.2f}")

        data = {}
        if bq_q_cost < rs_q_cost:
            diff = rs_q_cost - bq_q_cost
            pdiff = 100 * diff / rs_q_cost 
            data['diff'] = diff
            data['percent_diff'] = pdiff
            bq_cheaper[k] = data
        elif rs_q_cost < bq_q_cost:
            diff = bq_q_cost - rs_q_cost
            pdiff = 100 * diff / rs_q_cost 
            data['diff'] = diff
            data['percent_diff'] = pdiff
            rs_cheaper[k] = data
        else:
            print(f"{k}: queries same cost")

    print("-------RESULTS---------")
    print("")
    print("-------BQ CHEAPER---------")
    for k,_ in sorted(bq_cheaper.items(), key=lambda x: x[1]['diff']):
        print(f"{k}: ${bq_cheaper[k]['diff']}; {bq_cheaper[k]['percent_diff']:.2f}%")

    print("")
    print("-------RS CHEAPER---------")
    for k,_ in sorted(rs_cheaper.items(), key=lambda x: x[1]['diff']):
        print(f"{k}: ${rs_cheaper[k]['diff']}; {rs_cheaper[k]['percent_diff']:.2f}%")















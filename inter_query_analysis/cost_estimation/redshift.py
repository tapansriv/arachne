import json

size = ["1000", "2000"]
cluster = [1, 4, 8]
cost = 1.086

# outputs_noduck_GCP_0.12_1.086_6.25.json

redshift_cost = 0
redshift_time = 0
rs_load_cost = 0
rs_load_time = 0
bq_cost = 0
bq_time = 0

num_keys = 0
for s in size:
    for c in cluster:
        ccost = c * cost
        path = f"../parquet_{s}/real_data_rs{c}/outputs_noduck_GCP_0.12_{ccost}_6.25.json"
        data = json.load(open(path))
        for key in data:
            if data[key]["multi_cloud_plan"] == "stay":
                continue
            if data[key]["multi_cloud_plan"] == "move":
                continue
            num_keys += 1
            exec_data = data[key]["exec_details"]
            redshift_cost += exec_data["moved_cost"]
            redshift_time += exec_data["moved_runtime"]

            rs_load_cost += exec_data["load_cost"]
            rs_load_time += exec_data["load_runtime"]

            bq_cost += exec_data["stayed_cost"]
            bq_time += exec_data["stayed_runtime"]


total_cost = redshift_cost + rs_load_cost + bq_cost
total_time = redshift_time + rs_load_time + bq_time
print(f"EXTERNAL DATA: {num_keys} / 144")
print(f"TOTAL: ${total_cost} over {total_time} seconds or {total_time/3600} hours")
print(f"REDSHIFT: ${redshift_cost} over {redshift_time} seconds or {redshift_time/3600} hours")
print(f"LOAD: ${rs_load_cost} over {rs_load_time} seconds or {rs_load_time/3600} hours")
print(f"BQ: ${bq_cost} over {bq_time} seconds or {bq_time/3600} hours")
print("")
print("")

redshift_cost = 0
redshift_time = 0
rs_load_cost = 0
rs_load_time = 0
bq_cost = 0
bq_time = 0


num_keys = 0
for s in size:
    for c in cluster:
        ccost = c * cost
        path = f"../parquet_{s}/internal_rs{c}/outputs_noduck_GCP_0.12_{ccost}_6.25.json"
        data = json.load(open(path))
        for key in data:
            if data[key]["multi_cloud_plan"] == "stay":
                continue
            if data[key]["multi_cloud_plan"] == "move":
                continue
            # if data[key]["percent_diff"] < 1:
            #     continue
            # print(path)
            # print(key)
            # print(data[key]["percent_diff"])
            num_keys += 1

            # print(path)
            # print(key)
            exec_data = data[key]["exec_details"]
            # print(json.dumps(data[key], indent=4))
            redshift_cost += exec_data["moved_cost"]
            redshift_time += exec_data["moved_runtime"]

            rs_load_cost += exec_data["load_cost"]
            rs_load_time += exec_data["load_runtime"]

            bq_cost += exec_data["stayed_cost"]
            bq_time += exec_data["stayed_runtime"]


total_cost = redshift_cost + rs_load_cost + bq_cost
total_time = redshift_time + rs_load_time + bq_time
print(f"INTERNAL DATA: {num_keys} / 144")
print(f"TOTAL: ${total_cost} over {total_time} seconds or {total_time/3600} hours")
print(f"REDSHIFT: ${redshift_cost} over {redshift_time} seconds or {redshift_time/3600} hours")
print(f"LOAD: ${rs_load_cost} over {rs_load_time} seconds or {rs_load_time/3600} hours")
print(f"BQ: ${bq_cost} over {bq_time} seconds or {bq_time/3600} hours")












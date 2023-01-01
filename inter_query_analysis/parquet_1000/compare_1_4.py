import pandas as pd

f1 = "real_data_rs1/outputs_noduck_0.12_1.086_5.json"
f4 = "real_data_rs4/outputs_noduck_0.12_4.344_5.json"

data1 = pd.read_json(f1).T
data4 = pd.read_json(f4).T

multi1 = data1[data1["multi_cloud_plan"] == "multi"]
multi4 = data4[data4["multi_cloud_plan"] == "multi"]

overlap = set(multi1.index) & set(multi4.index)
multi1_only = set(multi1.index) - overlap
multi4_only = set(multi4.index) - overlap

print("----------r1----------")
print(multi1["percent_diff"])
for x in multi4_only:
    print(data1.loc[[x]]["percent_diff"])

print("----------r4----------")
print(multi4["percent_diff"])
for x in multi1_only:
    print(data4.loc[[x]]["percent_diff"])


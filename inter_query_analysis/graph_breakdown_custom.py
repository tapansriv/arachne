'''

'''
import matplotlib.pyplot as plt
import pandas as pd
import os
from argparse import ArgumentParser

# parser = ArgumentParser()
# parser.add_argument_group("--presentation", action="store_true", help="Print with background color")
# args = parser.parse_args()

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"
baseline = "#a2c0c7"

x = 8
y = 5
# if args.presentation:
#     presentation_color = "#DFE5D2"
#     plt.rcParams['axes.facecolor'] = presentation_color
#     plt.rcParams['savefig.facecolor'] = presentation_color
# 
cs = [duck_c_color, duck_color, bq_color]

folders = ["io_2", "mixed", "cpu_0.5"]
labels = ["W-IO", "W-Mixed", "W-CPU"]
assert len(folders) == len(labels)

gcp_outfile = "outputs_noduck_GCP_0.12_4.344_6.25.json"
aws_outfile = "outputs_noduck_AWS_0.09_4.344_6.25.json"


gcp_data = {}
gcp_baseline = {}
aws_data = {}
aws_baseline = {}
for i in range(len(folders)):
    folder = folders[i]
    label = labels[i]

    gcp_path = os.path.join("custom_workload", folder, gcp_outfile)
    aws_path = os.path.join("custom_workload", folder, aws_outfile)

    df = pd.read_json(gcp_path).T
    exec_details = df["exec_details"]["all"]
    vals = [exec_details["mvmt_cost"], exec_details["moved_cost"],
            exec_details["stayed_cost"]]
    gcp_data[label] = vals
    gcp_baseline[label] = [float(df["baseline_cost"].iloc[0])]

    df = pd.read_json(aws_path).T
    exec_details = df["exec_details"]["all"]
    vals = [exec_details["mvmt_cost"], exec_details["stayed_cost"],
            exec_details["moved_cost"]]
    aws_data[label] = vals
    aws_baseline[label] = [float(df["baseline_cost"].iloc[0])]
    

'''
PLOT GCP START DATA
'''
font = {'size' : 21}
plt.rc('font', **font)

fig = plt.figure(figsize=(x,y))
ax = fig.subplots()
# ax = plt.subplot(1, 2, 1)


arachne_data = pd.DataFrame(gcp_data,
    index=["Arachne Migration", "Arachne RS Cost", "Arachne BQ Cost"]
).T

baseline_data = pd.DataFrame(gcp_baseline,
    index=["BigQuery Baseline"]
).T

cs = [duck_c_color, duck_no_cut_color, baseline]
baseline_data.plot(kind="bar", stacked=True, width=0.4, 
                  ax=ax, position=0, rot=0, color=[bq_color])
arachne_data.plot(kind="bar", stacked=True, width=0.4, 
                   ax=ax, position=1, hatch='//', rot=0, color=cs)

ax.set_xlim(right=len(baseline_data)-0.5)
ax.set_ylim(top=100)
# ax.get_legend().remove()
plt.legend()
# handles1, labels1 = ax.get_legend_handles_labels()
ax.set_ylabel("Cost ($)")

outfile = f"graphs/custom_gcp_breakdown_tall.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2', bbox_inches='tight')
plt.clf()



'''
PLOT AWS START DATA
'''
arachne_data = pd.DataFrame(aws_data,
    index=["Arachne Migration", "Arachne RS Cost", "Arachne BQ Cost"]
).T

baseline_data = pd.DataFrame(aws_baseline,
    index=["Redshift Baseline"]
).T

fig = plt.figure(figsize=(x,y))
ax = fig.subplots()
# ax1 = plt.subplot(1, 2, 2)
baseline_data.plot(kind="bar", stacked=True, width=0.4, 
                  ax=ax, position=0, rot=0, color=[duck_color])
arachne_data.plot(kind="bar", stacked=True, width=0.4, 
                   ax=ax, position=1, hatch='//', rot=0, color=cs)

ax.set_xlim(right=len(baseline_data)-0.5)
ax.set_ylim(top=100)
plt.legend(loc='upper left')
# ax.get_legend().remove()
ax.set_ylabel("Cost ($)")

# handles2, labels2 = ax.get_legend_handles_labels()
# i = labels2.index("Redshift Baseline Costs")
# handles1.append(handles2[i])
# labels1.append(labels2[i])

# fig.legend(handles1, labels1, loc='upper center')

# plt.show()
outfile = f"graphs/custom_aws_breakdown_tall.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2', bbox_inches='tight')



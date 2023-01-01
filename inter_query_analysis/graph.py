import json 
import numpy as np
import matplotlib.pyplot as plt

def graph(keys, duck_100_times, duck_500_times, duck_times, duck_2000_times, outfile):
    arachne_color = "#ecae17"
    bq_color = "#455984"
    duck_color = "#a12721"
    duck_c_color = "#577836"
    duck_no_cut_color = "#c85327"
    ind = np.arange(len(keys))
    width = 0.18
    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()

    rect1 = ax.bar(ind,            duck_100_times, width, color=arachne_color, label="DuckDB Times SF100")
    rect2 = ax.bar(ind + width,    duck_500_times, width, color=duck_color, label="DuckDB Times SF500")
    rect3 = ax.bar(ind + 2*width,      duck_times, width, color=bq_color, label="DuckDB Times SF1000")
    rect4 = ax.bar(ind + 3*width, duck_2000_times, width, color=duck_c_color, label="DuckDB Times SF2000")

    # add some text for labels, title and axes ticks
    # ax.set_ylabel("Cost ($)")
    ax.set_xticks(ind + 2*width)
    ax.set_title("DuckDB Query Times in Chameleon by TPC-DS Scale Factor")
    ax.set_xlabel('Query Number')

    ax.set_xticklabels(keys)
    ax.legend()
    # ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    # plt.show()
    figure = plt.gcf()
    figure.set_size_inches(8, 6)
    plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()


f1 = open("parquet_100/duckdb_baseline_100.json")
f2 = open("parquet_500/duckdb_baseline_500.json")
f3 = open("/Users/Tapan/arachneDB/baseline/duck_chameleon_baseline.json")
f4 = open("parquet_2000/duckdb_baseline_2000.json")

duck_100 = json.load(f1)
duck_500 = json.load(f2)
duck = json.load(f3)
duck_2000 = json.load(f4)

# keys = duck_100.keys() & duck_500.keys() & duck.keys()


duck_100_times = []
duck_500_times = []
duck_times = []
duck_2000_times = []
keys = []
for k in duck_100:
    if k not in duck_500 or k not in duck or k not in duck_2000:
        continue
    keys.append(k)
    duck_100_times.append(duck_100[k])
    duck_500_times.append(duck_500[k])
    duck_times.append(duck[k])
    duck_2000_times.append(duck_2000[k])
    
chunks = 6
for i in range(5):
    chunk_keys = keys[10*i:10*(i+1)]
    chunk_duck_100_times = duck_100_times[10*i:10*(i+1)] 
    chunk_duck_500_times = duck_500_times[10*i:10*(i+1)] 
    chunk_duck_times = duck_times[10*i:10*(i+1)] 
    chunk_duck_2000_times = duck_2000_times[10*i:10*(i+1)] 
    outfile = f"chunk_2000_{i}"
    graph(chunk_keys, chunk_duck_100_times, chunk_duck_500_times, chunk_duck_times, chunk_duck_2000_times, outfile)

chunk_keys = keys[50:]
chunk_duck_100_times = duck_100_times[50:] 
chunk_duck_500_times = duck_500_times[50:] 
chunk_duck_times = duck_times[50:] 
chunk_duck_2000_times = duck_2000_times[50:] 
outfile = f"chunk_2000_5"
graph(chunk_keys, chunk_duck_100_times, chunk_duck_500_times, chunk_duck_times, chunk_duck_2000_times, outfile)

# outfile = "2000_total_times"
# graph(keys, duck_100_times, duck_500_times, duck_times, duck_2000_times, outfile)

print(len(keys))
print(len(duck_100))
print(len(duck_500))
print(len(duck))
print(len(duck_2000))











import json
import sys
from statistics import variance


fp1 = open('cockroach_baseline.json')
std_times = json.load(fp1)
fp1.close()

fp2 = open('cockroach_c_baseline.json')
c_times = json.load(fp2)
fp2.close()


keys = sorted(c_times.keys() & std_times.keys())
# for k in keys:
#     print(f"\"{k}\" ", end = "")
# print("")

cnt_5 = 0
cnt_10 = 0
lines = []
for k in keys:
    vals = []
    assert len(std_times[k]) == len(c_times[k])
    for t in range(len(std_times[k])):
        diff = c_times[k][t] - std_times[k][t]
        pdiff = 100 * diff / std_times[k][t]
        vals.append(pdiff)
        # if abs(pdiff) > 5:
        #     print(f"Trial {t}: {pdiff}%", end=" ")
            # print(f"{k}: {pdiff*100}%")
            # cnt_5 += 1    
        # if abs(pdiff) > 0.1:
            # cnt_10 += 1

    same = all(x > 0 for x in vals) or all(x < 0 for x in vals)
    if same:
        print(f"Key: {k}", end=" ")
        for t, pdiff in enumerate(vals):
            print(f"Trial {t}: {pdiff}%", end=" ")
        print("")

        if vals[0] > 0:
            zs = [str(round(v, 2)) for v in vals]
            foo = "%, ".join(zs)
            s = f"{k}: std faster, {foo}%"
            lines.append(s)
        elif vals[0] < 0:
            zs = [str(round(v, 2)) for v in vals]
            foo = "%, ".join(zs)
            s = f"{k}: calcite faster, {foo}%"
            lines.append(s)
        # print(f"Variance: {variance(vals)}")
    y = min([abs(x) for x in vals]) 
    if y > 5:
        cnt_5 += 1
    if y > 10:
        cnt_10 += 1
    

print(f"Num diff(5%): {cnt_5}; Num diff(10%): {cnt_10}; Total: {len(keys)}")
for l in lines:
    print(l)

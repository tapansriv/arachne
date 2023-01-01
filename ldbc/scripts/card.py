'''
1460 + #place
487700 + #person
46233610 # knows
 6687905 #intermediate
'''
import math
to_tb = math.pow(2,40)
to_tb = math.pow(10, 12)

total = (8+8+258)*1460 + 16*487700 + 24*46233610 
inter = 24*6687905 #intermediate
print(f"{total}, {inter}")

total_cost = (total / math.pow(2,40)) * 5
inter_cost = (inter / math.pow(2,40)) * 5
print(f"{total_cost}, {inter_cost}")
run_cost = (4.6225/3600) * 1.48
run_cost2 = (111.61064004898071/3600) * 1.48
run_cost3 = (89.472224474/3600) * 1.48
hybrid_cost = run_cost + inter_cost
print(f"{run_cost}, {inter_cost}, {run_cost2}")

print(f"Run baseline: ${run_cost2}, Run baseline cut: ${run_cost3}, hybrid: ${hybrid_cost}, bq: ${total_cost}, diff: {total_cost - hybrid_cost}")


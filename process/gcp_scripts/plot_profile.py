import numpy as np
import matplotlib.pyplot as plt

p1_runtime = 3647.040450574
p1_cost = (p1_runtime / 3600)
p1_bytes = 999_621_132_288
p1_tb = p1_bytes / 1_000_000_000_000

p2_runtime = 48757.962260 
p2_cost = (p2_runtime / 3600) 
p2_bytes = 42649780224
p2_tb = p2_bytes / 1_000_000_000_000

phase1_xs = [p1_cost]
phase1_ys = [p1_tb]

phase2_xs = [p2_cost]
phase2_ys = [p2_tb]

xs = np.linspace(0, 15, 54000)
price = 1.48
ys = (xs * price / 5)
plt.xticks(np.arange(0, 16, step=1))
plt.yticks(np.arange(0, 5, step=0.5))
plt.plot(xs, ys, color='black')
plt.scatter(phase1_xs, phase1_ys, color='red', label="Phase 1 BQ size vs. DuckDB runtime")
plt.text(p1_cost, p1_tb, f"({p1_cost:.2f}hrs, {p1_tb:.2f}TB)")

plt.scatter(phase2_xs, phase2_ys, color='green', label="Phase 2 BQ size vs. DuckDB runtime")
plt.text(p2_cost, p2_tb, f"({p2_cost:.2f}hrs, {p2_tb:.2f}TB)")

plt.title("Query 67 on the GCP VM vs. BigQuery Decision Boundary")
plt.legend()
# plt.show()

figure = plt.gcf()
figure.set_size_inches(8, 6)
plt.savefig("67_phases.png", dpi=100)

import json
import pandas as pd

f = open("duck_baseline.json")
# keys = ["0" + str(x) if x < 10 else str(x) for x in range(1, 100)]
times = json.load(f)

keys = list(times.keys())
values = list(times.values())
df = pd.DataFrame({'queries' : keys, 'times': values})

df['runtime'] = df['times'] * 4 / 3600 


pd.set_option("display.max_rows", None, "display.max_columns", None)
print(df.sort_values(['runtime'], ascending=False))
print(df[df['times'] < 1000].count())
print(df[df['runtime'] > 1]['runtime'].sum())
print(df[df['times'] > 0]['runtime'].sum())
# print(df.nlargest(10, 'times'))

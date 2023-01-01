import json

class Node:
    def __init__(self, name):
        self.name = name
        self.visited = False
        self.adjacent = []

    def add_adjacent(self, node):
        self.adjacent.append(node)


def dfs(node):
    node.visited = True
    for n in node.adjacent:
        if not n.visited:
            dfs(n)

fp = open("query_bit_vec.json")
x = json.load(fp)
# query_bit_vecs = {k: v for k, v in sorted(x.items(), key = lambda item: item[1])}
query_bit_vecs = x

table_indices = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]


table_nodes = []
for tbl in table_indices:
    node = Node(tbl)
    table_nodes.append(node)


query_nodes = []
for k in query_bit_vecs:
    print(k)
    node = Node(k)
    subset = query_bit_vecs[k]
    # use v to find dependencies and add
    for i in range(24):
        v = (subset >> i) & 0x1
        if v == 1:
            tbl = table_nodes[i]
            node.add_adjacent(tbl)
            tbl.add_adjacent(node)
            print(f"{node.name}; {tbl.name}") 

    query_nodes.append(node)


count = 0
for n in query_nodes:
    if not n.visited:
        count += 1
        dfs(n)

print(f"Number of connected components: {count}")

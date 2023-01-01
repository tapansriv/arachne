import json
import sys
import os
import glob
from argparse import ArgumentParser

def get_first_child(profile): 
    return profile['children'][0]

def traverse(current, parent, phase1):
    if parent is not None and current['name'] == "SEQ_SCAN":
        return [phase1]
    else:
        new_children = []
        for child in current['children']:
            new_child = traverse(child, current, phase1)
            new_children.extend(new_child)

        current['children'] = new_children
        return [current]

def build_profile(label):
    home = os.path.expanduser("~")
    match = f"{home}/arachneDB/profiles/{label}/{label}_*.json" 
    filenames = glob.glob(match)
    size = len(filenames)
    try:
        if size == 1:
            singleton(label)
            return

        i = 0
        while i < size - 1:
            merge(label, i, size-1)
            i = i + 1
        
        num = "".join([str(j) for j in range(size)])
        base = f"{label}_{num}.json"
        out = f"{label}_final.json"

        input_f = f"{home}/arachneDB/profiles/{label}/{base}" 
        output_f = f"{home}/arachneDB/profiles/{label}/{out}" 
        cmd = f"cp {input_f} {output_f}"
        print(cmd)
        os.system(cmd)
    except Exception as e: 
        print(str(e))

def singleton(label):
    home = os.path.expanduser("~")
    input_file = "0"
    out_file = f"final"
    f1 = open(f"{home}/arachneDB/profiles/{label}/{label}_{input_file}.json")
    p1_map = json.load(f1)
    phase1 = get_first_child(p1_map)

    fo = open(f"{home}/arachneDB/profiles/{label}/{label}_{out_file}.json", "w")
    json.dump(phase1, fo, indent=4)

def merge(label, curr_iter, max_iter):
    home = os.path.expanduser("~")
    input_file = "".join([str(j) for j in range(curr_iter+1)])
    out_file = f"{input_file}{curr_iter+1}"
    # print(input_file)
    # print(curr_iter+1)
    # print(out_file)
    # print(f"{home}/arachneDB/profiles/{label}/{label}_{input_file}.json")
    # print(f"{home}/arachneDB/profiles/{label}/{label}_{curr_iter+1}.json")
    f1 = open(f"{home}/arachneDB/profiles/{label}/{label}_{input_file}.json")
    f2 = open(f"{home}/arachneDB/profiles/{label}/{label}_{curr_iter+1}.json")

    p1_map = json.load(f1)
    p2_map = json.load(f2)

    phase1 = None
    phase2 = None
    if curr_iter == 0:
        phase1 = get_first_child(get_first_child(p1_map))
    else:
        phase1 = p1_map

    if (curr_iter + 1) == max_iter:
        phase2 = get_first_child(p2_map)
    else: 
        phase2 = get_first_child(get_first_child(p2_map))

    traverse(phase2, None, phase1)
    # print(json.dumps(
    #         phase2,
    #         indent=4,
    # ))

    fo = open(f"{home}/arachneDB/profiles/{label}/{label}_{out_file}.json", "w")
    json.dump(phase2, fo, indent=4)

def build_profiles(start):
    for i in range(start, 100):
        if i <= 2 or i == 36 or i == 67:
            continue
        label = str(i)
        if i < 10:
            label = "0" + label
        print(f"merging profile: {label}")
        build_profile(label)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        label = sys.argv[1]
        build_profile(label)
    else:    
        build_profiles(64)












def merge_01_2(label):
    home = os.path.expanduser("~")
    f12 = open(f"{home}/arachneDB/profiles/{label}_orig/{label}_01.json")
    f3  = open(f"{home}/arachneDB/profiles/{label}_orig/{label}_2.json")
    fo  = open(f"{home}/arachneDB/profiles/{label}_orig/{label}_012.json", "w")

    p12_map = json.load(f12)
    p3_map = json.load(f3)

    phase12 = p12_map
    phase3 = get_first_child(p3_map)
    traverse(phase3, None, phase12)
    print(json.dumps(
            phase3,
            indent=4,
    ))

    json.dump(phase3, fo, indent=4)

def merge_0_1(label):
    home = os.path.expanduser("~")
    f1 = open(f"{home}/arachneDB/profiles/{label}_orig/{label}_0.json")
    f2 = open(f"{home}/arachneDB/profiles/{label}_orig/{label}_1.json")
    fo = open(f"{home}/arachneDB/profiles/{label}_orig/{label}_01.json", "w")

    p1_map = json.load(f1)
    p2_map = json.load(f2)

    phase1 = get_first_child(get_first_child(p1_map))
    phase2 = get_first_child(get_first_child(p2_map))

    traverse(phase2, None, phase1)
    print(json.dumps(
            phase2,
            indent=4,
    ))

    json.dump(phase2, fo, indent=4)


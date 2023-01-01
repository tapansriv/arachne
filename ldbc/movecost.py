import json
import math

BYTES_TO_TB = math.pow(2,40)

size = json.load(open("ldbc_sizes.json"))

for k in size:
    aws = 90 * (size[k]/BYTES_TO_TB)
    gcp = 120 * (size[k]/BYTES_TO_TB)
    print(f"{k}: AWS: ${aws:.2f}; GCP: ${gcp:.2f}")

from argparse import ArgumentParser
import json

if __name__ == '__main__':
    parser = ArgumentParser(description="Initialize Arachne")
    parser.add_argument("--SLA", type=float, help="Optional workload SLA")
    parser.add_argument("sql_files", help="Path to folder with SQL files")
    parser.add_argument("src", choices=['redshift', 'bigquery'], help="Source execution backend")
    args = parser.parse_args()

    properties = {
                  'sql_directory': args.sql_files,
                  'source': args.src,
                  'SLA': args.SLA
                 }
    with open("config/arachne.json", 'w') as fp:
        json.dump(properties, fp, sort_keys=True, indent=4)

    '''
    create some scripts. Handle migration out of their source and transfer. Add
    hooks to create VMs for transfer tool. Work on authorization; name of
    RS cluster; name of BigQuery dataset;
    Should this just be a JSON config file? 
    God i hate yaml
    '''

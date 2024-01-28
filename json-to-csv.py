#!/usr/bin/env python3

import json
import csv
import sys


def main():
    input_name = sys.argv[1]
    print('reading ' + input_name)
    with open(input_name) as input_file:
        data = json.load(input_file)

    output_file = open(input_name.split('.')[0] + '.csv', 'w')
    csv_writer = csv.writer(output_file)


if __name__ == "__main__":
    main()

#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import csv
import os
from collections import defaultdict


entities = defaultdict(lambda: defaultdict(int))

files = sys.argv[1:]
sys.stderr.write(' '.join(files))

for fn in files:
    with open(fn) as tab:
        csv_reader = csv.reader(tab, delimiter=";")
        for row in csv_reader:
            try:
                root = row[2].decode('utf-8')
            except (IndexError):
                pass
            entities[root][fn]+=1

header = u';'.join([os.path.basename(f) for f in  files]).encode('utf-8')
sys.stdout.write(header)
sys.stdout.write('\n')

for entity, edict in entities.items():
    sys.stdout.write(entity.encode('utf-8'))
    sys.stdout.write(";".encode('utf-8'))
    estring = u';'.join([str(edict[fn]) for fn in files]) + '\n'
    sys.stdout.write(estring.encode('utf-8'))


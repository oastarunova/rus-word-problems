#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import csv
import os
from collections import defaultdict


entities = defaultdict(lambda: defaultdict(int))
dimensions = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))

units = []
files = sys.argv[1:]
sys.stderr.write(' '.join(files))

for fn in files:
    with open(fn) as tab:
        csv_reader = csv.reader(tab, delimiter=";")
        i = 0
        for row in csv_reader:
            if i == 0:
                units = [c.decode('utf-8') for c in row[3:]]
            else:
                try:
                    root = row[2].decode('utf-8')
                    for unit, val in zip(units, row[3:]):
                        if val == "1":
                            dimensions[unit][root][fn]+=1
                except (IndexError):
                    pass
                entities[root][fn]+=1
            i+=1


def make_header(flist):
    return u';'.join(['entity'] + [os.path.basename(f) for f in files]) + '\n'

def make_estring(entity, edict, flist):
    return u';'.join([entity] + [str(edict[fn]) for fn in files]) + '\n'

sys.stdout.write(make_header(files).encode('utf-8'))

for entity, edict in entities.items():
    estring = make_estring(entity, edict, files)
    sys.stdout.write(estring.encode('utf-8'))

for unit in units:
    with open("freq." + unit.encode('utf-8') + ".csv", 'wb') as ufile:
        ufile.write(make_header(files).encode('utf-8'))
        for entity, edict in dimensions[unit].items():
            estring = make_estring(entity, edict, files) 
            ufile.write(estring.encode('utf-8'))


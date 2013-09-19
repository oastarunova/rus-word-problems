#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import csv
import os
from collections import defaultdict
import argparse

aparser = argparse.ArgumentParser()
aparser.add_argument("-e", "--etype", help="Entity type", default=None)
aparser.add_argument("-o", "--outdir", help="Output directory", default=".")
aparser.add_argument("files", help="Input files", nargs=argparse.REMAINDER)
args = aparser.parse_args()


entities = defaultdict(lambda: defaultdict(int))
dimensions = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
units = []
sys.stderr.write(' '.join(args.files))
sys.stderr.write(u'EType: {0}\n'.format(args.etype))

for fn in args.files:
    with open(fn) as tab:
        csv_reader = csv.reader(tab, delimiter=";")
        i = 0
        wp = None
        wproots = set()
        for row in csv_reader:
            if i == 0:
                units = [c.decode('utf-8') for c in row[4:]]
            else:
                try:
                    wpid = row[0].decode('utf-8')
                    root = row[2].decode('utf-8')
                    etype = row[3].decode('utf-8')
                    if not wpid == wp:
                        wp = wpid
                        wproots = set()

                    if not args.etype or etype == args.etype:
                        if root not in wproots:
                            wproots.add(root)
                            entities[root][fn]+=1
                            dimsum = 0
                            for unit, val in zip(units, row[4:]):
                                if val == "1":
                                    dimensions[unit][root][fn]+=1
                                    dimsum+=1
                            if dimsum == 0:
                                dimensions['undef'][root][fn]+=1

                except (IndexError):
                    pass
            i+=1


def make_header(flist):
    return u';'.join(['entity'] + [os.path.basename(f) for f in args.files]) + '\n'

def make_estring(entity, edict, flist):
    return u';'.join([entity] + [str(edict[fn]) for fn in args.files]) + '\n'

if args.etype:
    prefix = u'{0}.'.format(args.etype).encode('utf-8')
else:
    prefix = u"freq.".encode('utf-8')

with open(os.path.join(args.outdir, prefix + "all.csv"),'wb') as o:
    o.write(make_header(args.files).encode('utf-8'))
    for entity, edict in entities.items():
        estring = make_estring(entity, edict, args.files)
        o.write(estring.encode('utf-8'))

for unit in units + ['undef']:
    with open(os.path.join(args.outdir, prefix + unit.encode('utf-8') + ".csv"), 'wb') as ufile:
        ufile.write(make_header(args.files).encode('utf-8'))
        for entity, edict in dimensions[unit].items():
            estring = make_estring(entity, edict, args.files) 
            ufile.write(estring.encode('utf-8'))


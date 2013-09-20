#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import xml.etree.cElementTree as e
from collections import defaultdict, namedtuple
import argparse
import itertools

aparser = argparse.ArgumentParser()
aparser.add_argument("-u", "--units", action="store_false")
aparser.add_argument("-i", "--infile", type=argparse.FileType('rb'), default=sys.stdin)
aparser.add_argument("-o", "--outfile", type=argparse.FileType('wb'), default=sys.stdout)
aparser.add_argument("-c", "--companions", action="store_true")
args = aparser.parse_args()

metric_order = u'длина расстояние вес цена скорость площадь время объем количество'.split()

class WordProblem(object):
    def __init__(self, wpid, units=True):
        self.wpid = wpid
        self._metrics = defaultdict(list)
        self._entities = set()
        self.units = units

    def metric(self, typ, val, unit):
        data = ' '.join([val, unit]).lower()
        self._metrics[typ.lower()].append(data)

    def entity(self, name, root, etype=""):
        self._entities.add((name.lower(), root.lower(), etype.lower()))

    @property
    def entities(self):
        return self._entities

    @property
    def roots(self):
        return zip(*self._entities)[1]

    @property
    def metrics(self):
        if self.units:
            return u';'.join([','.join(data for data in self._metrics[m]) for m in metric_order])
        else:
            out = []
            for m in metric_order:
                if self._metrics[m]:
                    out.append('1')
                else:
                    out.append('')
            return u';'.join(out)


    def __unicode__(self):
        return u'\n'.join([u';'.join([self.wpid, e[0], e[1], e[2], self.metrics]) for e in self._entities])

def wpi(fileobj):
    wp = WordProblem('None', units=args.units)
    for event, elem in e.iterparse(fileobj):
        if elem.tag == 'WPid':
            if wp.entities:
                yield wp
            wp = WordProblem(elem.get('val'), units=args.units)
        if elem.tag == 'Type':
            typ = elem.get('val')
        if elem.tag == 'Value':
            val = elem.get('val')
        if elem.tag == 'Unit':
            unit = elem.get('val')
            wp.metric(typ, val, unit)
        if elem.tag == 'Name':
            ename = elem.get('val')
        if elem.tag == 'Root':
            eroot = elem.get('val')
        if elem.tag == 'EType':
            etype = elem.get('val')
            wp.entity(ename, eroot, etype)


if args.companions:
    args.outfile.write(u'{0}\n'.format(u';'.join([])).encode('utf-8'))
    for wp in wpi(args.infile):
        for pair in itertools.permutations(set(wp.roots), 2):
            args.outfile.write(u'{0}\n'.format(u';'.join(pair)).encode('utf-8'))
else:
    args.outfile.write(u';'.join(['id', 'entity', 'root', 'type'] + metric_order).encode('utf-8'))
    args.outfile.write('\n')
    for wp in wpi(args.infile):
        args.outfile.write(unicode(wp).encode('utf-8'))
        args.outfile.write('\n')



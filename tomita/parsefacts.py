#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import xml.etree.cElementTree as e
from collections import defaultdict, namedtuple

if sys.argv[1] == '0':
    units = False
else:
    units = True

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
        return u','.join(self._entities)

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


wp = WordProblem('None', units=units)

sys.stdout.write(u';'.join(['id', 'entity', 'root', 'type'] + metric_order).encode('utf-8'))
sys.stdout.write('\n')

for event, elem in e.iterparse(sys.stdin):
    if elem.tag == 'WPid':
        if wp:
            sys.stdout.write(unicode(wp).encode('utf-8'))
            sys.stdout.write('\n')
        wp = WordProblem(elem.get('val'), units=units)
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


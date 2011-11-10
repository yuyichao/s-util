#!/usr/bin/env python

import os
import sys
import re

def space2_(name):
    return name.replace(' ', '_')

def del_extra_(name):
    ext_ = re.compile('_+')
    name = ext_.sub('_', name)
    ext_ = re.compile('^_*|_*$')
    return ext_.sub('', name)

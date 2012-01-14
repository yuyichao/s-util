#!/usr/bin/env python

import os
import sys
import re
from getopt import gnu_getopt
from os import path as _path

re_blanks = re.compile(r'\s+')
re__s = re.compile('_+')
re_leading_ = re.compile('^_*|_*$')
re_endslash = re.compile('/+$')

def blank2_(name):
    return re_blanks.sub('_', name)

def del_extra_(name):
    name = re__s.sub('_', name)
    return re_leading_.sub('', name)

def do_simplify(path):
    path = re_endslash.sub('', path)
    dirname = _path.dirname(path)
    basename = _path.basename(path)
    newname = blank2_(basename)
    newname = del_extra_(newname)
    os.rename(path, '%s/%s' % (dirname, newname))
    return

def _stdname(path, recursive=False, directory=False):
    print('path' + path)
    print(directory)
    if not _path.lexists(path):
        return
    if not _path.isdir(path):
        do_simplify(path)
        return
    children = os.listdir(path)
    for child in children:
        cpath = '%s/%s' % (path, child)
        if _path.isdir(cpath):
            if directory:
                do_simplify(cpath)
            if not recursive:
                continue
        _stdname(cpath, recursive=recursive, directory=directory)

def main():
    opts, args = gnu_getopt(sys.argv[1:], 'rd')
    recursive = False
    directory = False
    for o, a in opts:
        if o == '-r':
            recursive = True
        if o == '-d':
            directory = True
    if len(args) == 0:
        args = ['.']

    for path in args:
        _stdname(_path.abspath(path), recursive=recursive, directory=directory)

if __name__ == '__main__':
    main()

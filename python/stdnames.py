#!/usr/bin/env python

# Copyright 2010, 2011 Yu Yichao, Rudy
# yyc1992@gmail.com
# rudyht@gmail.com
#
# This file is part of s-util.
#
# s-util is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# s-util is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with s-util.  If not, see <http://www.gnu.org/licenses/>.
#

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

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

cmake_minimum_required(VERSION 2.6)
project(S_UTIL)
aux_source_directory(bash BASH_LIST)
aux_source_directory(python PYTHON_LIST)
set(PACKAGE_VERSION "0.3.1")
set(PACKAGE_NAME "s-util")
set(PACKAGE_TARNAME "s-util")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PACKAGE_VERSION}")

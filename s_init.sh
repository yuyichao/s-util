#!/bin/bash

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

S_U_VERSION=0.3.1

darg()
{
    if [[ $# == 0 ]] ;then
        n=0
    else
        n=$1
    fi
    let 'n >= 0' || return 1
    args=("${args[@]:0:n}" "${args[@]:n + 1}")
}

args=("$@")
set --
for ((i = 0;i < ${#args[@]};)) ;do
    case "${args[i]}" in
        -h|--help)
            if type s_shelp &> /dev/null ;then
                s_shelp
            else
                echo "$HELP_INFO"
            fi
            darg $i
            exit
            ;;
        -v|--version)
            echo ${S_U_VERSION}
            darg $i
            exit
            ;;
        *)
            let 'i++' || true
            ;;
    esac
done

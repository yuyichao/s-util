#!/bin/bash

d() {
    local path=''
    for ((i = 1;i <= $#;i++)) ;do
        path+=${!i}/
    done
    cd "$path"
}

_dirlst2array() {
    local IFS=:
    eval "$1"='($2)'
}

__s_util_init_alias() {
    local line alias_f
    alias_f=()
    ! [[ -z $XDG_CONFIG_DIRS ]] && {
        _dirlst2array xdg_dirs "$XDG_CONFIG_DIRS"
    }
    while read line; do
    done
}

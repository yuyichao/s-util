#!/bin/bash

d() {
    local path=''
    for ((i = 1;i <= $#;i++)) ;do
        path+=${!i}/
    done
    cd "$path"
}

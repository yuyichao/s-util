export S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    export PATH=${PATH}
else
    export PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi

_s_in_array()
{
    local i
    for ((i = 2;i <= $#;i++)) ;do
	if [[ "$1" == "${!i}" ]] ;then
	    return 0
	fi
    done
    return 1
}

__s_clr_rpt_frm_psbl()
{
    local i j n
    for ((i = 1;i < ${#COMP_WORDS[@]};i++)) ;do
	if ((i == COMP_CWORD)) ;then
	    continue
	fi
	n=${#possible[@]}
	for ((j = 0;j < n;j++)) ;do
	    if [[ "${COMP_WORDS[i]}" == "${possible[j]}" ]] ;then
		unset possible[j]
	    fi
	done
	possible=("${possible[@]}")
    done
}

_s_util_general_args()
{
    local general_args=(-h -v --version --help) i
    possible=("${general_args[@]}")
    __s_clr_rpt_frm_psbl
    for ((i = 1;i < ${#COMP_WORDS[@]};i++)) ;do
	if ((i == COMP_CWORD)) ;then
	    continue
	fi
	if _s_in_array "${COMP_WORDS[i]}" "${general_args[@]}" ;then
	    unset COMP_WORDS[i]
	    COMP_WORDS=("${COMP_WORDS[@]}")
	    if ((i < COMP_CWORD)) ;then
		let 'COMP_CWORD--'
	    fi
	    let 'i--'
	fi
    done
#    echo "${COMP_WORDS[@]}"
}

__s_util_g_comp()
{
    local cur possible command
    command="${COMP_WORDS[0]}"
    cur="${COMP_WORDS[COMP_CWORD]}"
    _s_util_general_args
    type "_${command}" &>/dev/null && "_${command}"
    COMPREPLY=($(compgen -W "${possible[*]}" -- ${cur}))
}

_clpbd()
{
    local opts fopt
    if [ "$COMP_CWORD" == 1 ] ;then
	opts="-c -d -p"
	possible=("${possible[@]}" $(compgen -W "${opts}" -- ${cur}))
	__s_clr_rpt_frm_psbl
	return 0
    else
	fopt="${COMP_WORDS[1]}"
	case "${fopt}" in
	    -c)
		possible=("${possible[@]}" $(compgen -f ${cur}))
		__s_clr_rpt_frm_psbl		
		return 0
		;;
	    -p|-d)
		possible=("${possible[@]}" $(cd /tmp/_s_clipboard 2> /dev/null && compgen -f ${cur}))
		__s_clr_rpt_frm_psbl
		return 0
		;;
	    *)
		return 0
		;;
	esac
    fi
}

reg_complete()
{
    local complete_list
    complete_list=(addpkla cback cempty clpbd import-cert recget spath spid)

    for command in "${complete_list[@]}" ;do
	complete -F __s_util_g_comp "${command}"
    done
}

reg_complete
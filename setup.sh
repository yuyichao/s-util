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
    [[ "${COMP_CWORD}" == 1 ]] && possible=("${general_args[@]}")
    for ((i = 0;i < ${#general_args[@]};i++)) ;do
	_s_in_array "${general_args[i]}" "${COMP_WORDS[@]:1}" && return 0
    done
    return 1
}

__s_util_g_comp()
{
    local cur possible command
    COMPREPLY=()
    command="${COMP_WORDS[0]}"
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"
    _s_util_general_args ||
    { type "_${command}" &>/dev/null && "_${command}"; }
    _s_in_array '' "${possible[@]}" && COMPREPLY=('')
    COMPREPLY=("${COMPREPLY[@]}" $(compgen -W "${possible[*]}" -- ${cur}))
}

__s_incld_rdm()
{
    [[ "${cur}" == "" ]] && possible=("${possible[@]}" '')    
}

_clpbd()
{
    local opts fopt
    if [ "$COMP_CWORD" == 1 ] ;then
	opts="-c --copy -d --delete -p --paste"
	possible=("${possible[@]}" $(compgen -W "${opts}" -- ${cur}))
	__s_clr_rpt_frm_psbl
	return 0
    else
	fopt="${COMP_WORDS[1]}"
	case "${fopt}" in
	    -c|--copy)
		possible=("${possible[@]}" $(compgen -f ${cur}))
		__s_clr_rpt_frm_psbl		
		return 0
		;;
	    -p|-d|--paste|--delete)
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

_xopen()
{
    possible=("${possible[@]}" $(compgen -f ${cur}))
}

_spid()
{
    __s_incld_rdm
}

_spath()
{
    local s_opts l_opts
    s_opts=(-r --reg -n --noexec -f --full)
    l_opts=(-p --path)
    _s_in_array "${prev}" "${l_opts[@]}" || {
	__s_incld_rdm
	possible=("${possible[@]}" "${s_opts[@]}" "${l_opts[@]}")
	__s_clr_rpt_frm_psbl
	return 0
    }
    _s_in_array "${prev}" -p --path && {
	possible=("${possible[@]}" $(compgen -f ${cur}))
	__s_clr_rpt_frm_psbl
	return 0
    }
}

reg_complete()
{
    local complete_list
    complete_list=(addpkla cback cempty clpbd import-cert recget spath spid xopen)

    for command in "${complete_list[@]}" ;do
	complete -F __s_util_g_comp "${command}"
    done
}

reg_complete
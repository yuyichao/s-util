S_UTIL_INSTALL_DIR="$(dirname "${BASH_SOURCE}")"
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

__s_one_in_array()
{
    local i list
    list=($1)
    for ((i = 0;i < ${#list[@]};i++)) ;do
	_s_in_array ${list[i]} "${@:2}" && return 0
    done
    return 1
}

__s_del_frm_psbl()
{
    local i n psbl_opt
    for psbl_opt in "$@" ;do
	n=${#possible[@]}
	for ((i = 0;i < n;i++)) ;do
	    [[ "${psbl_opt}" == "${possible[i]}" ]] && unset possible[i]
	done
	possible=("${possible[@]}")
    done
}

__s_clr_rpt_frm_psbl()
{
    local i j n pair_opts=("${l_opts[@]}" "${s_opts[@]}" "${general_opts[@]}") del
    for ((i = 1;i < ${#COMP_WORDS[@]};i++)) ;do
	((i == COMP_CWORD)) && continue
	_s_in_array "${COMP_WORDS[i]}" "${possible[@]}" || continue
	del="${COMP_WORDS[i]}"
	for ((j = 0;j < ${#pair_opts[@]};j++)) ;do
	    _s_in_array "${del}" ${pair_opts[j]} && __s_del_frm_psbl ${pair_opts[j]}
	done
	__s_del_frm_psbl ${del}
    done
}

_s_util_general_args()
{
    local general_opts=('-v --version' '-h --help') i
    [[ ${COMP_CWORD} == 1 ]] && [[ ${cur} =~ ^- ]] && possible=(${general_opts[@]})
    __s_clr_rpt_frm_psbl
    for ((i = 0;i < ${#general_opts[@]};i++)) ;do
	__s_one_in_array "${general_opts[i]}" "${COMP_WORDS[@]:1}" && return 0
    done
    return 1
}

__s_add_s_opts()
{
    _s_in_array "${prev}" ${l_opts[@]} || {
	possible=("${possible[@]}" ${s_opts[@]} ${l_opts[@]})
	return 0
    }
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
    { type "_${command}" &>/dev/null && "_${command}"; } &>/dev/null
    COMPREPLY=($(compgen -W "${possible[*]}" -- ${cur}))
    _s_in_array '' "${possible[@]}" && let "${#COMPREPLY[@]} > 0" && COMPREPLY=("${COMPREPLY[@]}" '')
}

__s_incld_rdm()
{
    [[ "${cur}" == "" ]] && possible=("${possible[@]}" '')
}

_clpbd()
{
    local l_opts clpdir i
    if [[ $prev == -u ]] || [[ $prev == --user ]] ;then
	local usrlst=($(compgen -u "${cur}")) homeof n
	n=${#usrlst[@]}
	for ((i = 0;i < n;i++)) ;do
	    eval homeof=~${usrlst[i]}
	    case ${homeof}/ in
		~*|//|/var/*|/srv/*|/bin/*|/sbin/*|/proc/*)
		    unset usrlst[i]
		    ;;
	    esac
	done
	possible=("${possible[@]}" "${usrlst[@]}")
	return 0
    fi
    local usrhome=~ action
    for ((i = 1;i < ${#COMP_WORDS[@]};i++)) ;do
	((i == COMP_CWORD)) && continue
	case "${COMP_WORDS[i]}" in
	    -u|--user)
		eval usrhome=~"${COMP_WORDS[i+1]}"
		;;
	    -c|--copy)
		action="copy"
		;;
	    -d|--delete)
		action="delete"
		;;
	    -p|--paste)
		action="paste"
		;;
	esac
    done
    { [[ $usrhome =~ ^~ ]] || [[ $usrhome == / ]] ; } && return
    clpdir=${usrhome}/.sutil/_s_clipboard
    if [[ ${cur} =~ ^- ]] || { [[ $cur == "" ]] && [[ $action == "" ]]; } ;then
	if [[ $action == "" ]] ;then
	    l_opts=('-c --copy' '-d --delete' '-p --paste' '-u --user')
	else
	    l_opts=('-u --user')
	fi
	possible=("${possible[@]}" $(compgen -W "${l_opts[*]}" -- ${cur}))
	__s_clr_rpt_frm_psbl
	return 0
    else
	case "${action}" in
	    copy)
		possible=("${possible[@]}" $(compgen -f ${cur}))
		__s_clr_rpt_frm_psbl
		type compopt &>/dev/null && compopt -o filenames
		return 0
		;;
	    paste|delete)
		possible=("${possible[@]}" $(cd "${clpdir}" 2> /dev/null && compgen -f ${cur}))
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
    type compopt &>/dev/null && compopt -o filenames
}

_spid()
{
    __s_incld_rdm
}

_spath()
{
    local s_opts l_opts
    s_opts=('-r --noreg' '-n --noexec' '-f --full')
    l_opts=('-p --path')
    __s_add_s_opts && {
	__s_incld_rdm
	__s_clr_rpt_frm_psbl
	return 0
    }
    _s_in_array "${prev}" -p --path && {
	possible=("${possible[@]}" $(compgen -f ${cur}))
	type compopt &>/dev/null && compopt -o filenames
	__s_clr_rpt_frm_psbl
	return 0
    }
}

_addpkla()
{
    __s_incld_rdm
}

_recget()
{
    local s_opts l_opts
    s_opts=('-b --background')
    l_opts=()
    __s_add_s_opts
    __s_clr_rpt_frm_psbl
    __s_incld_rdm
}

_import-cert()
{
    __s_incld_rdm
}

_cempty()
{
    possible=("${possible[@]}" $(compgen -f ${cur}))
    type compopt &>/dev/null && compopt -o filenames
    __s_clr_rpt_frm_psbl
    __s_incld_rdm
}

_cback()
{
    local s_opts l_opts
    s_opts=(-r)
    l_opts=()
    __s_add_s_opts
    possible=("${possible[@]}" $(compgen -f ${cur}))
    type compopt &>/dev/null && compopt -o filenames
    __s_clr_rpt_frm_psbl
    __s_incld_rdm
}

_mitclass()
{
    possible=()
}

_dlblk()
{
    local s_opts l_opts
    s_opts=('-s --show')
    l_opts=()
    __s_add_s_opts
    possible=("${possible[@]}" $(compgen -f ${cur}))
    type compopt &>/dev/null && compopt -o filenames
    __s_clr_rpt_frm_psbl
}

_lsutil()
{
    local s_opts l_opts
    l_opts=('-a --add' '-d --delete')
    __s_add_s_opts && {
	__s_clr_rpt_frm_psbl
	return 0
    }
    _s_in_array "${prev}" -a --add -d --delete && {
	possible=("${possible[@]}" $(compgen -c ${cur}))
	__s_clr_rpt_frm_psbl
	return 0
    }

}

__reg_complete()
{
    local complete_list
    complete_list=(addpkla cback cempty clpbd import-cert recget spath spid xopen mitclass dlblk lsutil)
    for command in "${complete_list[@]}" ;do
	complete -F __s_util_g_comp "${command}"
    done
}

__reg_complete
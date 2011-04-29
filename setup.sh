export S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    export PATH=${PATH}
else
    export PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi

_s_util_general_args()
{
    local general_args='-h -v --version --help'
    for ((i = 1;i < ${#COMP_WORDS[@]};i++)) ;do
	if ((i == COMP_CWORD)) ;then
	    continue
	fi
	if [[ " ${general} " =~ " ${COMP_WORDS[i]} " ]] ;then
	    COMP_WORDS=("${COMP_WORDS[@]:0:i}" "${COMP_WORDS[@]:i + 1}")
	    if ((i < COMP_CWORD)) ;then
		let 'COMP_CWORD--'
	    fi
	    let 'i--'
	fi
    done
    possible=(${general_args})
}

__s_util_g_comp()
{
    local cur possible command
    command="${COMP_WORDS[0]}"
    cur="${COMP_WORDS[COMP_CWORD]}"
    _s_util_general_args
    type "_${command}" && "_${command}"
    COMPREPLY=($(compgen -W "${possible[@]}" -- ${cur}))
}

_clpbd()
{
    local opts fopt
    if [ "$COMP_CWORD" == 1 ] ;then
	opts="-c -d -p"
	possible=("${possible[@]}" $(compgen -W "${opts}" -- ${cur}))
	return 0
    else
	fopt="${COMP_WORDS[1]}"
	case "${fopt}" in
	    -c)
		possible=("${possible[@]}" $(compgen -f ${cur}))
		return 0
		;;
	    -p|-d)
		possible=("${possible[@]}" $(cd /tmp/_s_clipboard 2> /dev/null && compgen -f ${cur}))
		return 0
		;;
	    *)
		return 0
		;;
	esac
    fi
}

local complete_list
complete_list=(addpkla cback cempty clpbd import-cert recget spath spid)

for command in "${complete_list[@]}" ;do
    complete -F __s_util_g_comp "${command}"
done
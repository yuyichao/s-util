export S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    export PATH=${PATH}
else
    export PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi

_clpbd()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    if [ "$COMP_CWORD" == 2 ] ;then
	opts="-c -d -p"
	COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
	return 0
    else
	fopt="${COMP_WORDS[2]}"
	case "${fopt}" in
	    -c)
		COMPREPLY=($(compgen -f ${cur}))
		return 0
		;;
	    -p|-d)
		COMPREPLY=($(cd /tmp/_s_clipboard 2> /dev/null && compgen -f ${cur}))
		return 0
		;;
	    *)
		COMPREPLY=()
		return 0
		;;
	esac
    fi
}

complete -F _clpbd clpbd

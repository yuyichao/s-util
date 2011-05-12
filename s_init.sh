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
	    let 'i++'
	    ;;
    esac
done

S_U_VERSION=0.1.0
for ((i = 1;i <= $#;)) ;do
    case ${!i} in
	-h|--help)
	    if type s_shelp &> /dev/null ;then
		s_shelp
	    else
		echo "$HELP_INFO"
	    fi
	    shift $i
	    exit
	    ;;
	-v|--version)
	    echo ${S_U_VERSION}
	    shift $i
	    exit
	    ;;
	*)
	    let 'i++'
	    ;;
    esac
done

S_U_VERSION=0.0.1
for ((i = 1;i < $#;i++)) ;do
    case ${!i} in
	-h|--help)
	    if type s_shelp &> /dev/null ;then
		s_shelp
	    fi
	    exit
	    ;;
	-v|--version)
	    echo ${S_U_VERSION}
	    exit
    esac
done
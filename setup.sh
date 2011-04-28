export S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    export PATH=${PATH}
else
    export PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi

_plaste()
{
    if [[ "$BASH_SOURCE" =~ ^/ ]] ;then
	dir="$(dirname "${BASH_SOURCE}")/_pb"
    else
	dir="${PWD}/$(dirname "${BASH_SOURCE}")/_pb"
    fi
    COMPREPLY=($(find "${dir}" -mindepth 1 -maxdepth 1 -name "${2}*" -exec basename {} \;))
}

complete -F _plaste plaste
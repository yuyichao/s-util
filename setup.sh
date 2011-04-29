export S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    export PATH=${PATH}
else
    export PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi

_fpaste()
{
    dir=/tmp/_s_clipboard
    COMPREPLY=($(find "${dir}" -mindepth 1 -maxdepth 1 -name "${2}*" -exec basename {} \; 2> /dev/null))
}

complete -F _fpaste fpaste
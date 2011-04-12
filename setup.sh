export S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    export PATH=${PATH}
else
    export PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi

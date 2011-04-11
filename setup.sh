S_UTIL_INSTALL_DIR=@@install_dir
if [[ ":${PATH}:" =~ ":${S_UTIL_INSTALL_DIR}:" ]] ;then
    PATH=${PATH}
else
    PATH="${PATH}:${S_UTIL_INSTALL_DIR}"
fi
export PATH
# Copyright 2010, 2011 Yu Yichao, Rudy
# yyc1992@gmail.com
# rudyht@gmail.com
#
# This file is part of s-util.
#
# s-util is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# s-util is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with s-util.  If not, see <http://www.gnu.org/licenses/>.
#

cmake_minimum_required(VERSION 2.6)
project(S_UTIL)
file(GLOB_RECURSE BASH_LIST "bash/*")
file(GLOB_RECURSE PYTHON_LIST "python/*.py")
set(PACKAGE_VERSION "0.3.1")
set(PACKAGE_NAME "s-util")
set(PACKAGE_TARNAME "s-util")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PACKAGE_VERSION}")

if(NOT DEFINED BIN_INSTALL_DIR)
  set(BIN_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/bin")
endif(NOT DEFINED BIN_INSTALL_DIR)

if(NOT DEFINED BASH_COMPLETION_INSTALL_DIR)
  set(BASH_COMPLETION_INSTALL_DIR "/etc/bash_completion.d")
endif(NOT DEFINED BASH_COMPLETION_INSTALL_DIR)

if(NOT DEFINED PROFILE_INSTALL_DIR)
  set(PROFILE_INSTALL_DIR "/etc/profile.d")
endif(NOT DEFINED PROFILE_INSTALL_DIR)

foreach(pyfile ${PYTHON_LIST})
  string(REGEX REPLACE "^.*/(.*)\\.py\$" "\\1" binfile "${pyfile}")
  install(FILES "${pyfile}"
    DESTINATION "${BIN_INSTALL_DIR}"
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
    RENAME "${binfile}")
endforeach(pyfile)

foreach(shfile ${BASH_LIST})
  string(REGEX REPLACE "^.*/(.*)\$" "\\1" binfile "${shfile}")
  if("${shfile}" MATCHES "\\.sh\$")
    install(FILES "${shfile}"
      DESTINATION "${BIN_INSTALL_DIR}"
      PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
      RENAME "${binfile}")
  else("${shfile}" MATCHES "\\.sh\$")
    install(FILES "${shfile}"
      DESTINATION "${BIN_INSTALL_DIR}"
      PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
      RENAME "${binfile}")
  endif("${shfile}" MATCHES "\\.sh\$")
endforeach(shfile)

install(FILES "bash-completion.sh"
  DESTINATION "${BASH_COMPLETION_INSTALL_DIR}"
  RENAME "${s-util.sh}")

install(FILES "profile.sh"
  DESTINATION "${PROFILE_INSTALL_DIR}"
  RENAME "${s-util.sh}")

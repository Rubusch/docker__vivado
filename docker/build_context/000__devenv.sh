#!/bin/sh -e
## basic setup, fix/check permissions and ssh known_hosts
##
## call, optionally with additionally mounted folders:
## $0 <folder1> <folder2>...

MY_USER="$(whoami)"
MY_HOME="/home/${MY_USER}"
SSH_DIR="${MY_HOME}/.ssh"
SSH_KNOWN_HOSTS="${SSH_DIR}/known_hosts"
CONFIGS_DIR="${MY_HOME}/configs"

## permissions
for item in "${MY_HOME}/.gitconfig" "${SSH_DIR}" "${CONFIGS_DIR}" $*; do
    test -e "${item}" || continue
    if [ ! "${MY_USER}" = "$( stat -c %U "${item}" )" ]; then
        ## may take some time
        sudo chown "${MY_USER}":"${MY_USER}" -R "${item}"
    fi
done

## ssh known_hosts
touch "${SSH_KNOWN_HOSTS}"
for item in "github.com" "bitbucket.org"; do
    SSH_HOSTS="$( grep "${item}" -r "${SSH_KNOWN_HOSTS}" )" || true
    if [ -z "${SSH_HOSTS}" ]; then
        ssh-keyscan "${item}" >> "${SSH_KNOWN_HOSTS}"
    fi
done

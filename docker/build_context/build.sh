#!/bin/sh -e
MY_USER="$(whoami)"
MY_HOME="$(pwd)"
WORKSPACE="${MY_HOME}/workspace"

000__devenv.sh "${WORKSPACE}"
110__prepare.sh "${WORKSPACE}"

echo "READY."
echo

#!/bin/sh -e
MY_USER="$(whoami)"
MY_HOME="$(pwd)"
WORKSPACE="${MY_HOME}/workspace"

00_devenv.sh "${WORKSPACE}"
10_prepare-petalinux.sh "${WORKSPACE}"

echo "READY."
echo

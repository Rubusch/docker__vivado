#!/bin/sh -e
MY_USER="$(whoami)"
MY_HOME="$(pwd)"
WORKSPACE="${MY_HOME}/workspace"

000__devenv.sh

echo "READY."
echo

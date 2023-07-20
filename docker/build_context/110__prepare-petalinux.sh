#!/bin/sh -e

WORKSPACE="${1}"

## prepare mounted buildfolder
FIRST="$(ls -A "${WORKSPACE}")" || true
if [ -z "${FIRST}" ]; then
	if [ -d "${WORKSPACE}.template" ]; then
		echo "setting up petalinux"
		ln -sf "${WORKSPACE}.template/"{*,.[aA-zZ]*} "${WORKSPACE}"/
	else
		echo "setting up petalinux: failed, no '${WORKSPACE}.templte' found"
	fi
else
	echo "NOTE: the folder '${WORKSPACE}' was not empty, in case copy petalinux content manually from '${WORKSPACE}.template' to '${WORKSPACE}'"
fi

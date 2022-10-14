#!/bin/sh -e
## builds the container, or if already built, logs into the build environment
DRYRUN="${1}"

die()
{
	echo "FAILED! $@."
	exit 1
}

build()
{
	CONTAINER_NAME="$(grep "container_name:" -r "${1}/docker-compose.yml" | awk -F: '{ print $2 }' | tr -d ' ')"
	cd "${1}"
	if [ -n "${2}" ]; then
		docker-compose build
	else
		docker-compose up --exit-code-from "${CONTAINER_NAME}"
	fi
	cd -
}

TOPDIR="$(pwd)"
test -z "${DOCKERDIR}" && DOCKERDIR="docker"
test -z "${DOWNLOADDIR}" && DOWNLOADDIR="download"
BASE_IMAGE="$(grep "ARG DOCKER_BASE=" -r "${DOCKERDIR}/build_context/Dockerfile" | awk -F= '{ print $2 }' | tr -d '"')"
BASE_IMAGE_TAG="$(grep "ARG DOCKER_BASE_TAG" -r "${DOCKERDIR}/build_context/Dockerfile" | awk -F= '{ print $2 }' | tr -d '"')"
IMAGE="$( grep "^FROM" -HIrn ${DOCKERDIR}/build_context/Dockerfile | awk '{ print $NF }' )"
VERSION="$( echo ${IMAGE} | awk -F'-' '{print $NF}' )"
CONTAINER="$(docker images | grep "${BASE_IMAGE}" | grep "${BASE_IMAGE_TAG}" | awk '{print $3}')"
## NB: check for particular user, when different user prefixed images are around

## checks
if [ -z "${CONTAINER}" ]; then
    ## base not around, build
	DO_BUILDBASE=1
fi
CONTAINER="$( docker images | grep "${IMAGE}" | awk '{print $3}' )"
if [ -z "${CONTAINER}" ]; then
	## container is not around, build
	DO_BUILD=1
else
	## container around, start
	cd "${DOCKERDIR}"
	xhost +
	docker-compose -f ./docker-compose.yml run --rm "${IMAGE}" /bin/bash

	## exit success
	xhost -
	exit 0
fi

## build
if [ -n "${DO_BUILDBASE}" ]; then
	git clone "https://github.com/Rubusch/docker__petalinux.git" "${BASE_IMAGE}" || die "Could not clone petalinux repo"
	cd "${BASE_IMAGE}"
	git checkout "${BASE_IMAGE_TAG}"
	mv ${TOPDIR}/${DOWNLOADDIR}/petalinux-v${VERSION}-*-installer.run "./docker/build_context/" || die "No petalinux installer provided! Please, put a petalinux-v${VERSION}-*-installer.run file in ${DOWNLOADDIR}"
	./setup.sh
	cd "${TOPDIR}"
fi
if [ -n "${DO_BUILD}" ]; then
	mv "${TOPDIR}/${DOWNLOADDIR}"/.env "${TOPDIR}/${DOCKERDIR}"/ || die "No .env file provided"
	mv ${TOPDIR}/${DOWNLOADDIR}/Xilinx_Unified_${VERSION}_*_Lin64.bin "${TOPDIR}/${DOCKERDIR}/build_context" || die "No Xilinx_Unified_${VERSION}_*_Lin64.bin file provided"
	build "${DOCKERDIR}" "${DRYRUN}"
	cd "${TOPDIR}/${DOCKERDIR}"
	echo "!!! Docker finished, overwriting ${DOCKERDIR}/.env file with default user, in case adjust manually !!!"
	echo "UID=$(id -u)" > .env
	echo "GID=$(id -g)" >> .env
fi

echo "READY."

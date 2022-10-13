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

## NB: check for particular user, when different user prefixed images are around
CONTAINER="$(docker images | grep "${BASE_IMAGE}" | grep "${BASE_IMAGE_TAG}" | awk '{print $3}')"

## check: is base container already around?
if [ -z "${CONTAINER}" ]; then
	## base container is NOT around

	## check: is installer provided?
	BASEIMAGE_INSTALLER="$( ls ${DOWNLOADDIR}/petalinux-v${VERSION}-*-installer.run )"
	if [ -z "${BASEIMAGE_INSTALLER}" ]; then
		die "No petalinux installer provided! Please, put a petalinux-v${VERSION}-*-installer.run file in ${DOWNLOADDIR}"
	fi

	## build base image
	git clone "https://github.com/Rubusch/docker__petalinux.git" "${BASE_IMAGE}"
	cd "${BASE_IMAGE}"
	git checkout "${BASE_IMAGE_TAG}"
	mv "${TOPDIR}/${BASEIMAGE_INSTALLER}" "./docker/build_context/"
	./setup.sh
	cd -
fi

## build overlay container
CONTAINER="$( docker images | grep "${IMAGE}" | awk '{print $3}' )"
if [ -z "${CONTAINER}" ]; then
	## container is not around, build
	mv "${DOWNLOADDIR}"/.env "${DOCKERDIR}"/ || die "No .env file provided"
	mv "${DOWNLOADDIR}/Xilinx_Unified_${VERSION}_*_Lin64.bin" "${DOCKERDIR}/build_context" || die "No Xilinx_Unified_${VERSION}_*_Lin64.bin file provided"
	build "${DOCKERDIR}" "${DRYRUN}"
	cd "${DOCKERDIR}"
	echo "!!! Docker finished, overwriting ${DOCKERDIR}/.env file with default user, in case adjust manually !!!"
	echo "UID=$(id -u)" > .env
	echo "GID=$(id -g)" >> .env
else
	## container around, start up
	cd "${DOCKERDIR}"
	xhost +
	docker-compose -f ./docker-compose.yml run --rm "${IMAGE}" /bin/bash
	xhost -
fi
echo "READY."

#!/bin/sh -e
DOXXXER_UID="$(id -u)"
DOXXXER_GID="$(id -g)"
USER="$(whoami)"

die()
{
	echo "FAILED! $@."
	exit 1
}

## MAIN
if [ -d ".git" ]; then
	if [ "main" = "$( git rev-parse --abbrev-ref HEAD )" ]; then
		die "THIS IS MAIN, PLEASE CHANGE TO ONE OF THE GIT BRANCHES"
	fi
fi

test -z "${DOCKERDIR}" && DOCKERDIR="docker"
test -z "${DOWNLOADDIR}" && DOWNLOADDIR="download"
TOPDIR="$(pwd)"
DOCKERFILE="${TOPDIR}/${DOCKERDIR}/Dockerfile"

if [ ! -f "${DOCKERFILE}" ]; then
	die "Dockerfile not found at ${DOCKERFILE}"
fi

VERSION="$(grep -m 1 "^ARG XILINXVERSION=" "${DOCKERFILE}" | cut -d'"' -f2)"

if [ -z "${VERSION}" ]; then
	die "Could not extract XILINXVERSION from ${DOCKERFILE}"
fi

IMAGE="vivado-${VERSION}"
CONTAINER="$( docker images -q ${IMAGE} 2> /dev/null )" || true

if [ -z "${CONTAINER}" ]; then
	if [ -z "${XILINXMAIL}" ] || [ -z "${XILINXLOGIN}" ]; then
		die "Please provide XILINXMAIL and XILINXLOGIN environment variables."
	fi

	INSTALLER_BIN=$(find "${TOPDIR}/${DOWNLOADDIR}" -name "FPGAs_AdaptiveSoCs_Unified_${VERSION}_*_Lin64.bin" | head -n 1)
	if [ -z "${INSTALLER_BIN}" ]; then
		die "No FPGAs_AdaptiveSoCs_Unified_${VERSION}_*_Lin64.bin file found in '${TOPDIR}/${DOWNLOADDIR}'"
	fi
	chmod a+x ${INSTALLER_BIN}

	PETALINUX_BIN=$(find "${TOPDIR}/${DOWNLOADDIR}" -name "petalinux-v${VERSION}-*-installer.run" | head -n 1)
	if [ -z "${PETALINUX_BIN}" ]; then
		die "No petalinux-v${VERSION}-*-installer.run file found in '${TOPDIR}/${DOWNLOADDIR}'"
	fi
	chmod a+x ${PETALINUX_BIN}

	cd "$DOCKERDIR"

	docker build \
		--tag ${IMAGE} \
		--build-context installer="${TOPDIR}/${DOWNLOADDIR}" \
		--build-arg DOXXXER_UID=${DOXXXER_UID} \
		--build-arg DOXXXER_GID=${DOXXXER_GID} \
		--build-arg USER=${USER} \
		--build-arg XILINXMAIL=${XILINXMAIL} \
		--build-arg XILINXLOGIN=${XILINXLOGIN} \
		./
	cd "${TOPDIR}"

else
	cd "${DOCKERDIR}"
	APP="/bin/bash"
	if [ ! -e .env ]; then
		APP=""
		echo "DOXXXER_UID=$(id -u)" > .env
		echo "DOXXXER_GID=$(id -g)" >> .env
	fi

	docker run \
		--rm \
		--net host \
		--name ${IMAGE} \
		-u ${DOXXXER_UID}:${DOXXXER_GID} \
		-it \
		--privileged \
		-e USER \
		-e DISPLAY=$DISPLAY \
		--env-file .env \
		--group-add 20 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ~/.Xauthority:/home/${USER}/.Xauthority:ro \
		-v ~/.gitconfig:/home/${USER}/.gitconfig:ro \
		-v ~/.ssh:/home/${USER}/.ssh:ro \
		-v ./configs:/tmp/host_configs:ro \
		-v ./workspace:/home/${USER}/workspace \
		${IMAGE} \
		${APP}

	exit 0
fi

echo "READY."

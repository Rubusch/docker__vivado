################################################################################
FROM ubuntu:22.04 AS peta-vivado-2023.1-nightly
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

################################################################################
## the USER is needed to make it available as --build-arg
ARG USER="${USER}"
ARG UID="${UID}"
ARG GID="${GID}"
ARG XILINXMAIL="${XILINXMAIL}"
ARG XILINXLOGIN="${XILINXLOGIN}"
ARG DISPLAY="${DISPLAY}"
ENV MY_CONFIGS="/home/$USER/configs"
ENV SCRIPTS="/home/$USER/scripts"
ENV XILINXVERSION="2023.1"

################################################################################
## set up apt fully functional
USER root
RUN dpkg --add-architecture i386

## NB: don't do "apt-get upgrade -y", for avoiding trouble
## incompatible through packaging solutions
RUN apt-get update && apt-get autoremove -y --purge

## container essentials
RUN apt-get install -y \
	locales \
	sudo \
	bc \
	libelf-dev \
	python3-all \
	python3-dialog \
	rsync \
	binutils \
	bzip2 \
	libc6-dev \
	fakeroot \
	udev \
	hdparm \
	xmlto \
	curl \
	bin86 \
	patch \
	aptitude \
	expect \
	device-tree-compiler \
	build-essential \
	flex \
	bison \
	autoconf \
	libtool \
	gcc \
	gcc-multilib \
	g++ \
	automake \
	make \
	wget \
	net-tools \
	iproute2 \
	socat \
	tftpd \
	iputils-ping \
	openssl \
	libssl-dev \
	openssh-server \
	libselinux1 \
	tar \
	unzip \
	gzip \
	xz-utils \
	cpio \
	tofrodos \
	debianutils \
	gawk \
	diffstat \
	chrpath \
	util-linux \
	sysvinit-utils \
	gnupg

## development
RUN apt-get install -y \
	screen \
	i2c-tools \
	cmake \
	apt-file \
	psmisc \
	u-boot-tools \
	tree \
	mc \
	colordiff \
	tig \
	dos2unix \
	x11-apps \
	vim \
	emacs \
	emacs-goodies-el \
	emacs-goodies-extra-el \
	exuberant-ctags \
	graphviz \
	doxygen \
	git-all \
	file

################################################################################
## system settings

## set shell to bash instead of dash non-interactively
## ref: https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

## locale settings
USER root
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

################################################################################
## user settings
USER root
RUN groupadd -g "$GID" "$USER"
RUN useradd -m -u "$UID" -g "$GID" -s /bin/bash "$USER"

RUN echo "$USER  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /usr/local
RUN chown -R "${USER}":"${USER}" /usr/local

RUN mkdir -p /opt
RUN chown -R "${USER}":"${USER}" /opt

RUN adduser "$USER" sudo
RUN adduser "$USER" dialout

################################################################################
## tftp server
USER root
RUN echo -e '\
service tftp\n\
    {\n\
    protocol = udp\n\
    port = 69\n\
    socket_type = dgram\n\
    wait = yes\n\
    user = nobody\n\
    server = /usr/sbin/in.tftpd\n\
    server_args = /tftpboot\n\
    disable = no\n\
    }\n\
' > /etc/xinetd.d/tftp

RUN mkdir /tftpboot
RUN chmod -R 777 /tftpboot
RUN chown -R nobody /tftpboot
RUN /etc/init.d/xinetd stop tftp
RUN /etc/init.d/xinetd start tftp

################################################################################
## configs
USER ${USER}
WORKDIR /home/${USER}
RUN rm -rf .local
RUN ln -s /usr/local .local

## bash config
RUN rm -f /home/$USER/.bashrc && ln -s ${MY_CONFIGS}/.bashrc /home/$USER/

## vim config
RUN rm -f /home/$USER/.vimrc && ln -s ${MY_CONFIGS}/.vimrc /home/$USER/

## emacs config
RUN rm -f /home/$USER/.emacs && ln -s ${MY_CONFIGS}/.emacs /home/$USER/

## user
RUN echo "export USER=${USER}" >> /home/$USER/.profile

## ssh preparations
RUN mkdir -p /home/$USER/.ssh

## PETALINUX ##################################################################
## container additionals
USER root

## NB: don't do "apt-get upgrade -y", for avoiding trouble
## incompatible through packaging solutions
RUN apt-get update && apt-get autoremove -y --purge

## xilinx needed packages
RUN apt-get install -y \
	mercurial \
	libc6-i386 \
	bsdmainutils \
	google-perftools \
	libegl1-mesa \
	libsdl1.2-dev \
	pylint \
	python3 \
	python3-pip \
	python3-git \
	python3-jinja2 \
	python3-pexpect \
   	perl \
	liberror-perl \
	haveged \
	lib32stdc++6 \
	libgtk2.0-0:i386 \
	libfontconfig1:i386 \
	libx11-6:i386 \
	libxext6:i386 \
	libxrender1:i386 \
	libsm6:i386 \
	xinetd \
	xterm \
	texinfo \
	zlib1g-dev \
	zlib1g:i386 \
	putty \
	pax \
	mtd-utils \
	x11-utils \
	xtrans-dev \
	libxcb-randr0-dev \
	libxcb-xtest0-dev \
	libxcb-xinerama0-dev \
	libxcb-shape0-dev \
	libxcb-xkb-dev \
	ncurses-dev \
	libncurses5 \
	libncurses5-dev \
	libncursesw5-dev \
	libncurses5:i386 \
	libtinfo5 \
	libstdc++6:i386 \
	dpkg-dev:i386 \
	ocl-icd-libopencl1 \
	opencl-headers \
	ocl-icd-opencl-dev \
	python3-subunit \
	mesa-common-dev \
	liblz4-tool \
	lz4

## GUI IDEs may require the following...
RUN apt-get install -y \
	'^libxcb.*-dev' \
	libx11-xcb-dev \
	libglu1-mesa-dev \
	libxrender-dev \
	libxi-dev \
	libxkbcommon-dev \
	libxkbcommon-x11-dev

## needed for setup
RUN apt-get install -y \
	expect \
	zstd

################################################################################
## prepare installation
USER root
RUN mkdir /tools
RUN sudo chown ${USER}:${USER} -R /tools

RUN mkdir /home/$USER/scripts
COPY *.run /home/$USER/scripts/
COPY *.exp /home/$USER/scripts/

RUN sudo chown ${USER}:${USER} -R /home/$USER/scripts

################################################################################
## installation
USER $USER
RUN mkdir /home/$USER/workspace

WORKDIR /home/$USER/workspace
RUN /home/$USER/scripts/100__install-*.exp ../scripts/petalinux-*-installer.run

## cleanup
USER root
RUN mv /home/$USER/workspace /home/$USER/workspace.template
RUN rm -rf /home/$USER/scripts

## link config environment
RUN rm -f /home/$USER/.petalinux-sys.env && ln -s ${MY_CONFIGS}/.petalinux-sys.env /home/$USER/

## fix missing "python" link
USER root
RUN test -e /usr/bin/python || ln -s /usr/bin/python3 /usr/bin/python

## VIVADO ######################################################################
## container additionals
## - the interactive installer script is based on expect
## - vitis, e.g. the create system project dialog still needs something to show
##   up, installing xfce4 will fix by its dependencies
USER root
RUN apt-get update && apt-get autoremove -y --purge
RUN apt-get install -y \
	expect \
	xfce4

################################################################################
## prepare Xilinx installation
USER root
RUN mkdir -p /tools
RUN sudo chown ${USER}:${USER} -R /tools

RUN mkdir $SCRIPTS
#RUN --mount=type=bind,source=build_context/,target=$SCRIPTS
COPY *.bin $SCRIPTS/
COPY *.exp $SCRIPTS/
COPY *.patch $SCRIPTS/

RUN chown ${USER}:${USER} -R $SCRIPTS
RUN chmod a+x $SCRIPTS/*.exp
RUN chmod a+x $SCRIPTS/*.bin

################################################################################
## installation
USER $USER

WORKDIR $SCRIPTS
RUN ./Xilinx_*.bin --keep --noexec --target /usr/local/
RUN ./210_*.exp

## adjust install config via install-config.patch
#RUN cd /home/$USER/.Xilinx/ && patch -p1 -i $SCRIPTS/200_install-config.patch

RUN ./220_*.exp "$XILINXMAIL" "$XILINXLOGIN"
RUN /usr/local/xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config /home/$USER/.Xilinx/install_config.txt

## install libs
WORKDIR /tools/Xilinx/Vitis/$XILINXVERSION/scripts
RUN sudo ./installLibs.sh

## install JTAG driver
WORKDIR /tools/Xilinx/Vivado/$XILINXVERSION/data/xicom/cable_drivers/lin64/install_script/install_drivers
RUN sudo ./install_drivers

## cleanup
USER root
RUN rm -rf $SCRIPTS

################################################################################
## command mode
USER $USER
WORKDIR /home/$USER
COPY *.sh /usr/local/bin/
CMD ["/bin/bash", "/usr/local/bin/build.sh"]

################################################################################
## ATTENTION: multistage build
##
## based on current USER and TAG, DOCKER_BASE
##
################################################################################
## base image settings
ARG USER="${USER}"
ARG DOCKER_BASE="peta-2020.2"
ARG DOCKER_BASE_TAG="peta2020.2-DEVEL"

################################################################################
## base image
FROM ${USER}/${DOCKER_BASE}:${DOCKER_BASE_TAG} AS xilinx-2020.2
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## environment (applied ARG/ENV must come after FROM declaration)
ARG USER="${USER}"
ARG XILINXMAIL="${XILINXMAIL}"
ARG XILINXLOGIN="${XILINXLOGIN}"
ARG DISPLAY="${DISPLAY}"
ENV SCRIPTS="/home/$USER/scripts"
ENV XILINXVERSION="2020.2"


################################################################################
## container additionals
USER root
RUN apt-get install -y expect


################################################################################
## prepare Xilinx installation
USER root
RUN mkdir -p /tools
RUN sudo chown ${USER}:${USER} -R /tools

RUN mkdir $SCRIPTS
COPY *.bin $SCRIPTS/
COPY *.exp $SCRIPTS/
COPY *.patch $SCRIPTS/
COPY *.zip $SCRIPTS/

RUN chown ${USER}:${USER} -R $SCRIPTS
RUN chmod a+x $SCRIPTS/*.exp
RUN chmod a+x $SCRIPTS/*.bin


################################################################################
## installation
USER $USER

WORKDIR $SCRIPTS
RUN ./Xilinx_*.bin --keep --noexec --target /usr/local/
RUN ./10_*.exp

## adjust install config via install-config.patch
#RUN cd /home/$USER/.Xilinx/ && patch -p1 -i $SCRIPTS/install-config.patch

RUN ./20_*.exp "$XILINXMAIL" "$XILINXLOGIN"
RUN /usr/local/xsetup --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --batch Install --config /home/$USER/.Xilinx/install_config.txt

## install libs
WORKDIR /tools/Xilinx/Vitis/$XILINXVERSION/scripts
RUN sudo ./installLibs.sh

## install JTAG driver
WORKDIR /tools/Xilinx/Vivado/$XILINXVERSION/data/xicom/cable_drivers/lin64/install_script/install_drivers
RUN sudo ./install_drivers

## Xilnix y2k patch
## https://support.xilinx.com/s/article/76960?language=en_US
WORKDIR $SCRIPTS
RUN unzip y2k22_patch-*.zip
WORKDIR /tools/Xilinx
RUN cp -arf $SCRIPTS/y2k22_patch .
RUN export LD_LIBRARY_PATH=/tools/Xilinx/Vivado/2020.2/tps/lnx64/python-3.8.3/lib/ && /tools/Xilinx/Vivado/2020.2/tps/lnx64/python-3.8.3/bin/python3 ./y2k22_patch/patch.py

## cleanup
USER root
RUN rm -rf $SCRIPTS


################################################################################
## command mode
USER $USER
WORKDIR /home/$USER
COPY *.sh /usr/local/bin/
CMD ["/bin/bash", "/usr/local/bin/build.sh"]

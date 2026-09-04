# syntax=docker/dockerfile:1

ARG XILINXVERSION="2026.1"

FROM ubuntu:24.04 AS final
ENV DEBIAN_FRONTEND=noninteractive

ARG XILINXVERSION
ARG USER DOXXXER_UID DOXXXER_GID XILINXMAIL XILINXLOGIN
ENV XILINXVERSION=${XILINXVERSION}

RUN apt-get update && apt-get install -y wget software-properties-common && \
    wget http://kernel.org && \
    wget http://kernel.org || true && \
    dpkg --add-architecture i386 && apt-get update && \
    (dpkg -i libtinfo5_*.deb || apt-get install -f -y) && rm -f libtinfo5_*.deb

RUN apt-get install -y \
    '^libxcb.*-dev' \
    apt-file \
    aptitude \
    autoconf \
    automake \
    bc \
    bin86 \
    bind9-utils \
    binutils \
    bison \
    bsdmainutils \
    build-essential \
    bzip2 \
    chrpath \
    cmake \
    colordiff \
    cpio \
    curl \
    debianutils \
    device-tree-compiler \
    diffstat \
    dos2unix \
    doxygen \
    dpkg-dev:i386 \
    emacs \
    expect \
    exuberant-ctags \
    fakeroot \
    file \
    flex \
    g++ \
    gawk \
    gcc \
    gcc-multilib \
    git \
    git-all \
    gnupg \
    google-perftools \
    graphviz \
    gzip \
    haveged \
    hdparm \
    i2c-tools \
    iproute2 \
    iputils-ping \
    kmod \
    libc6-dev \
    libc6-i386 \
    libegl1 \
    libelf-dev \
    liberror-perl \
    libfontconfig1 \
    libfontconfig1:i386 \
    libgl1 \
    libglx0 \
    libgl1-mesa-dri \
    libglu1-mesa-dev \
    libgtk2.0-0:i386 \
    liblz4-tool \
    libncurses6 \
    libncurses5-dev \
    libncursesw5-dev \
    libsdl1.2-dev \
    libselinux1 \
    libsm6:i386 \
    libssl-dev \
    libstdc++6:i386 \
    libtool \
    libx11-6 \
    libx11-6:i386 \
    libx11-xcb-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb-xtest0-dev \
    libxext6 \
    libxext6:i386 \
    libxi-dev \
    libxi6 \
    libxinerama1 \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrandr2 \
    libxrender-dev \
    libxrender1 \
    libxrender1:i386 \
    libxtst6 \
    locales \
    lz4 \
    make \
    mc \
    mercurial \
    mesa-common-dev \
    mtd-utils \
    net-tools \
    ocl-icd-libopencl1 \
    ocl-icd-opencl-dev \
    opencl-headers \
    openssh-server \
    openssl \
    patch \
    pax \
    perl \
    psmisc \
    putty \
    pylint \
    python3-all \
    python3-dialog \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    python3-venv \
    repo \
    rsync \
    screen \
    socat \
    sudo \
    sysvinit-utils \
    tar \
    texinfo \
    tig \
    tofrodos \
    tree \
    u-boot-tools \
    udev \
    unzip \
    util-linux \
    vim \
    wget \
    x11-apps \
    x11-utils \
    xfce4 \
    xinetd \
    xmlto \
    xterm \
    xtrans-dev \
    xz-utils \
    zlib1g \
    zlib1g-dev \
    zlib1g:i386 \
    zstd \
    && apt-get autoremove -y --purge \
    && rm -rf /var/lib/apt/lists/*

## Bypass dash reconfigure limitation in Ubuntu 24.04 natively via symlinking
RUN ln -sf /bin/bash /bin/sh

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

## Overwrite system user profiles if host mirrors collision index spaces
RUN if id "ubuntu" >/dev/null 2>&1; then userdel -r ubuntu || true; fi && \
    if getent group "$DOXXXER_GID"; then groupdel "$DOXXXER_GID" || true; fi

RUN groupadd -g "$DOXXXER_GID" "$USER" && \
    useradd -m -u "$DOXXXER_UID" -g "$DOXXXER_GID" -s /bin/bash "$USER" && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser "$USER" sudo && \
    adduser "$USER" dialout

RUN mkdir -p /tools && chown ${USER}:${USER} /tools

WORKDIR /tmp
SHELL ["/bin/bash", "-c"]

RUN --mount=from=installer,target=/mnt/installer \
    --mount=type=bind,source=./install_config.txt,target=/tmp/install_config.txt <<'EOF'
set -ex

export XILINXMAIL="${XILINXMAIL}"
export XILINXLOGIN="${XILINXLOGIN}"

INSTALLER_BIN=$(find /mnt/installer -name "FPGAs_AdaptiveSoCs_Unified_SDI_*${XILINXVERSION}_*_Lin64.bin" | head -n 1)
if [ -z "$INSTALLER_BIN" ]; then
    echo "Installer binary not found!"
    exit 1
fi

"$INSTALLER_BIN" --keep --noexec --target /tmp/extracted_xsetup
cd /tmp/extracted_xsetup

cat << 'EXP210' > /tmp/210.exp
match_max 100000
spawn ./xsetup -b ConfigGen
expect -re "Please choose:"
send -- "1\r"
expect eof
EXP210
su "${USER}" -c 'expect /tmp/210.exp'

cat << 'EXP220' > /tmp/220.exp
match_max 100000
spawn ./xsetup -b AuthTokenGen
expect -re "E-mail Address:"
send -- "$env(XILINXMAIL)\r"
expect -re "Password:"
send -- "$env(XILINXLOGIN)\r"
expect eof
EXP220
su "${USER}" -c 'expect /tmp/220.exp'

mkdir -p /tools/Xilinx
chown -R ${USER}:${USER} /tools/Xilinx

mkdir -p /home/${USER}/.Xilinx
cp /tmp/install_config.txt /home/${USER}/.Xilinx/install_config.txt
chown -R ${USER}:${USER} /home/${USER}/.Xilinx

su "${USER}" -c './xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config /home/${USER}/.Xilinx/install_config.txt'

cd /tools/Xilinx/${XILINXVERSION}/data/xicom/cable_drivers/lin64/install_script/install_drivers
./install_drivers

## Note: usually this script will print errors/warnings,
## but dependencies should anyway already be resolved
/tools/Xilinx/${XILINXVERSION}/Vitis/scripts/installLibs.sh || true

rm -rf /tools/Xilinx/.xinstall
rm -rf /tmp/extracted_xsetup /home/${USER}/.Xilinx /tmp/*.exp
EOF

RUN ln -sf /usr/bin/python3 /usr/bin/python

COPY <<EOF /usr/local/bin/entrypoint.sh
#!/bin/bash
set -e

MY_USER="\$(whoami)"
MY_HOME="/home/\${MY_USER}"
WORKSPACE="\${MY_HOME}/workspace"

HOST_CONFIG_DIR="/tmp/host_configs"
if [ -d "\${HOST_CONFIG_DIR}" ]; then
    echo "=== Synchronizing User Configuration Profiles ==="
    for cfg_path in "\${HOST_CONFIG_DIR}"/.*; do
        cfg=\$(basename "\${cfg_path}")
        if [ "\${cfg}" != "." ] && [ "\${cfg}" != ".." ]; then
            if [ -f "\${cfg_path}" ]; then
                echo "Syncing configuration profile: \${cfg}"
                rm -f "\${MY_HOME}/\${cfg}"
                cp "\${cfg_path}" "\${MY_HOME}/\${cfg}"
                chown "\${MY_USER}":"\${MY_USER}" "\${MY_HOME}/\${cfg}"
            fi
        fi
    done
fi

INTERNAL_SSH="\${MY_HOME}/.ssh_internal"
mkdir -p "\${INTERNAL_SSH}"

if [ -d "\${MY_HOME}/.ssh" ]; then
    cp -rp \${MY_HOME}/.ssh/* "\${INTERNAL_SSH}/" 2>/dev/null || true
fi

sudo chown -R "\${MY_USER}":"\${MY_USER}" "\${INTERNAL_SSH}"
chmod 700 "\${INTERNAL_SSH}"
if [ -f "\${INTERNAL_SSH}/id_rsa" ]; then chmod 600 "\${INTERNAL_SSH}/id_rsa"; fi
if [ -f "\${INTERNAL_SSH}/id_ed25519" ]; then chmod 600 "\${INTERNAL_SSH}/id_ed25519"; fi

cat << 'SSHCFG' > "\${INTERNAL_SSH}/config"
Host *
    StrictHostKeyChecking accept-new
    UpdateHostKeys yes
    UserKnownHostsFile ~/.ssh_internal/known_hosts
SSHCFG
chmod 600 "\${INTERNAL_SSH}/config"

echo "=== Initializing Development Environment ==="

if [ -e "\${MY_HOME}/.gitconfig" ] && [ "\${MY_USER}" != "\$(stat -c %U "\${MY_HOME}/.gitconfig")" ]; then
    echo "Adjusting permissions for gitconfig..."
    sudo chown "\${MY_USER}":"\${MY_USER}" "\${MY_HOME}/.gitconfig"
fi

if [ -d "\${WORKSPACE}" ] && [ "\${MY_USER}" != "\$(stat -c %U "\${WORKSPACE}")" ]; then
    echo "Adjusting permissions for workspace..."
    sudo chown "\${MY_USER}":"\${MY_USER}" -R "\${WORKSPACE}"
fi

export SSH_OPTS="-F \${INTERNAL_SSH}/config"
alias ssh="ssh -F \${INTERNAL_SSH}/config"
alias git="GIT_SSH_COMMAND='ssh -F \${INTERNAL_SSH}/config' git"

echo "=== Environment Ready ==="
echo

exec "\$@"
EOF

RUN chmod +x /usr/local/bin/entrypoint.sh

USER $USER
WORKDIR /home/$USER

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

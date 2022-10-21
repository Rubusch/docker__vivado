[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

# Container for Xilinx Vivado

Docker for Xilinx Vivado IDE. Staged build on external base container.  

**!!! ATTENTION !!!  

!!! Check out a git BRANCH to build an environment !!!  
!!! The "main" branch will not build !!!**  


## Tools Needed

```
$ sudo apt-get install -y libffi-dev libssl-dev
$ sudo apt-get install -y python3-dev
$ sudo apt-get install -y python3-pyqt5 python3-pyqt5.qtwebengine python3-pypathlib
$ sudo apt-get install -y python3 python3-pip
$ pip3 install docker-compose
```
Make sure, ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``.  

Make sure to have docker setup correctly, e.g.  
```
$ sudo usermod -aG docker $USER
```

Make sure to have:  
  - ``Xilinx_Unified_*_Lin64.bin`` downloaded
  - ``petalinux-*-installer.run`` from https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/archive.html
  - A xilinx account is needed to install the packages (usually free), and to provide the credentials


## Prepare

Prepare build by providing files..

!!! **Prepare Xilinx login credentials, append the following variables** !!!   


### 1. Provide Xinlinx Vivado Installer

```
$ mkdir ./download
$ cp <Downloads>/Xilinx_Unified_*_Lin64.bin ./download
```

### 2. Provide Petalinux Installer

Only if no corresponding petalinux container is still around.  

```
$ cp <Downloads>/petalinux-*-installer.run ./download
```

### 3. Provide Credentials

Only when installing Vivado, not needed for usage.

```
$ echo "UID=$(id -u)" > ./download/.env
$ echo "GID=$(id -g)" >> ./download/.env
$ vi ./download/.env
    ...
    XILINXMAIL='<my email>'
    XILINXLOGIN='<my xilinx password>'
```
NB: Credentials are only needed for container creation. They are not stored
inside the container, or after the container was built. The entries can be
removed from the .env file again, if not overwritten during installation!
The .env is not tracked by git.


## Build and Usage

```
$ ./setup.sh
```


### Manual Usage

```
$ cd ./docker
$ xhost +
$ docker-compose -f ./docker-compose.yml run --rm xilinx-2020.2 /bin/bash
docker$  vivado &
...
$ xhost -
```

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

# Container for Xilinx Vivado

Docker for Xilinx Vivado IDE. Staged build on external base container.  
**!!! Check out a tagged version in order to build!!!**


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


## Build

Prepare build by providing the Xilinx Vivado Linux 64 .bin file, e.g.  

```
$ cp <Downloads>/Xilinx_Unified_*_Lin64.bin ./docker/build_context/
```

!!! **Prepare Xilinx login credentials, append the following variables** !!!   

```
$ vi ./docker/.env
    UID=<my uid>
    GID=<my gid>
    XILINXMAIL='<my email>'
    XILINXLOGIN='<my xilinx password>'
```
NB: this is only needed for container creation, it is not stored inside the
container, and after the container was build, the entries can be removed from
the .env file again! The .env is also not tracked by git.  

run the installation

```
$ ./setup.sh
```

issue: installLibs.sh not found  
check: did you prepare ./docker.env as above? Is the internet connection available?


## Usage

```
$ cd ./docker
$ xhost +
$ docker-compose -f ./docker-compose.yml run --rm xilinx-2020.2 /bin/bash
docker$  vivado &
```

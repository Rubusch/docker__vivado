[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

# Container for Xilinx Vivado

Docker for Xilinx Vivado IDE. A monolythic build image not based on external base container.  

- [Petalinux-Vivado-2020.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2020.1)
- [Petalinux-Vivado-2020.2](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2020.2)
- [Petalinux-Vivado-2022.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2022.1)
- [Petalinux-Vivado-2022.2](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2022.2)
- [Petalinux-Vivado-2023.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2023.1)

**!!! Check out a tagged version in order to build!!!**


## Requirements

Have `docker` installed.  

Make sure to have:  
  - A downloaded ``Xilinx_Unified_*_Lin64.bin``
  - A downloaded ``petalinux-*-installer.run`` from https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/archive.html
  - A xilinx account is needed to install the packages (usually free), and to provide the credentials


## Preparation

!!! **Prepare Xilinx login credentials, append the following variables** !!!  


Provide Xilinx Vivado installer, Petalinux installer and credentials. Download the installer from the official page.  

```
$ mkdir ./download
$ cp <Downloads>/Xilinx_Unified_*_Lin64.bin ./download
$ cp <Downloads>/petalinux-*-installer.run ./download
$ echo "export UID=$(id -u)" > ./download/.env
$ echo "export GID=$(id -g)" >> ./download/.env
$ vi ./download/.env
    ...
    export XILINXMAIL='<my email>'
    export XILINXLOGIN='<my xilinx password>'
```
NB: XILINXMAIL and XILINXLOGIN are only needed for container creation. They are not stored inside the container. The entries can be removed from the .env file after installation! The .env is not tracked by git.  

Example:  
```
$ tree -a ./download/
    ./download/
    ├── .env
    ├── petalinux-v2023.2-*-installer.run
    └── FPGAs_AdaptiveSoCs_Unified_2023.2_*_Lin64.bin

    0 directories, 3 files

$ cat ./download/.env
    export UID=105601750
    export GID=105600513
    export XILINXMAIL=my.email@company.com
    export XILINXLOGIN='password123'
```
After building the image, the folder `download` can be removed. The installer files will be in the respective `build_context` folders and can be equally removed.

## Build

```
$ source ./download/.env
$ ./setup.sh
```
First usage will end, w/o giving a prompt. It should display a message, though.  
```
$ ./setup.sh
<prepares workspace folder>
```

## Usage

```
$ ./setup.sh
docker$  vivado &
    ...
```

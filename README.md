[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

# Container for Xilinx Vivado

Docker for Xilinx Vivado IDE. A monolythic build image not based on external base container.  

- [Petalinux-Vivado-2020.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2020.1)
- [Petalinux-Vivado-2020.2](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2020.2)
- [Petalinux-Vivado-2022.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2022.1)
- [Petalinux-Vivado-2022.2](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2022.2)
- [Petalinux-Vivado-2023.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2023.1)
- [Petalinux-Vivado-2024.1](https://github.com/Rubusch/docker__peta-vivado/tree/xilinx-2024.1)

NB: Starting 2024.2: No pre-installed petalinux tooling anymore.
- [Vivado-2024.2](https://github.com/Rubusch/docker__vivado/tree/xilinx-2024.2)


**!!! Check out a tagged version in order to build!!!**


## Requirements

Have `docker` installed.  

Make sure to have:  
  - A downloaded ``FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin``
  - A xilinx account is needed to install the packages (usually free), and to provide the credentials
  - Environment variables UID, GID, XILINXMAIL and XILINXLOGIN set in the environment


## Preparation

!!! **Prepare Xilinx login credentials, append the following variables** !!!  


Provide Xilinx Vivado installer and credentials, as UID and GID (note, if UID and GID is already set in your environment, skip the following). Download the installer from the official page.  

```
$ mkdir ./download
$ cp <Downloads>/FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin ./download
$ echo "export UID=$(id -u)" > ./download/env
$ echo "export GID=$(id -g)" >> ./download/env
$ vi ./download/env
    export UID=105601750
    export GID=105600513
```

NB: `XILINXMAIL` and `XILINXLOGIN` are only needed for container creation. They are not stored inside the container. When added to the env file they can also be sourced with the ids for the environment.  

After building the image, the folder `download` can be removed. The installer files will be in the respective `build_context` folders and can be equally removed.

## Build

```
$ export XILINXMAIL=my.email@company.com
$ export XILINXLOGIN='password123'
$ source ./download/env
$ ./setup.sh
```
First usage will end, w/o giving a prompt. It should display a message, though.  
```
$ ./setup.sh

Preparing docker images - please re-run this script to enter the container image!
setting up petalinux
READY.
```

## Usage

```
$ ./setup.sh
*************************************************************************************************************************************************
The PetaLinux source code and images provided/generated are for demonstration purposes only.
Please refer to https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/2741928025/Moving+from+PetaLinux+to+Production+Deployment
 for more details
*************************************************************************************************************************************************
PetaLinux environment set to '/home/lrub/workspace'
[INFO] Checking free disk space
[INFO] Checking installed tools
[INFO] Checking installed development libraries
[INFO] Checking network and other services
setting environment
PATH=/tools/Xilinx/Vitis_HLS/2024.2/bin:/tools/Xilinx/Model_Composer/2024.2/bin:/tools/Xilinx/Vitis/2024.2/bin:/tools/Xilinx/Vitis/2024.2/gnu/microblaze/lin/bin:/tools/Xilinx/Vitis/2024.2/gnu/microblaze/linux_toolchain/lin64_le/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch64/lin/aarch64-linux/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch64/lin/aarch64-none/bin:/tools/Xilinx/Vitis/2024.2/gnu/armr5/lin/gcc-arm-none-eabi/bin:/tools/Xilinx/Vitis/2024.2/aietools/bin:/tools/Xilinx/Vitis/2024.2/gnu/riscv/lin/riscv64-unknown-elf/bin:/tools/Xilinx/Vivado/2024.2/bin:/tools/Xilinx/DocNav:/home/lrub/workspace/sysroots/x86_64-petalinux-linux/usr/bin:/home/lrub/workspace/sysroots/x86_64-petalinux-linux/usr/sbin:/home/lrub/workspace/sysroots/x86_64-petalinux-linux/bin:/home/lrub/workspace/sysroots/x86_64-petalinux-linux/sbin:/home/lrub/workspace/scripts:/home/lrub/workspace/components/xsct/gnu/microblaze/lin/bin:/home/lrub/workspace/components/xsct/gnu/armr5/lin/gcc-arm-none-eabi/bin:/home/lrub/workspace/components/xsct/gnu/aarch64/lin/aarch64-linux/bin:/home/lrub/workspace/components/xsct/gnu/aarch64/lin/aarch64-none/bin:/home/lrub/workspace/components/xsct/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/home/lrub/workspace/components/xsct/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

xilinx<20:15:21>::lrub("~/");
(docker) $  vivado &
    ...
```

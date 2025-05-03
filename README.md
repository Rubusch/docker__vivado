[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

# Container for Xilinx Vivado

Docker for Xilinx Vivado IDE development environment.  

- [Petalinux-Vivado-2020.1](https://github.com/Rubusch/docker__vivado/tree/xilinx-2020.1)
- [Petalinux-Vivado-2020.2](https://github.com/Rubusch/docker__vivado/tree/xilinx-2020.2)
- [Petalinux-Vivado-2022.1](https://github.com/Rubusch/docker__vivado/tree/xilinx-2022.1)
- [Petalinux-Vivado-2022.2](https://github.com/Rubusch/docker__vivado/tree/xilinx-2022.2)
- [Petalinux-Vivado-2023.1](https://github.com/Rubusch/docker__vivado/tree/xilinx-2023.1)
- [Petalinux-Vivado-2024.1](https://github.com/Rubusch/docker__vivado/tree/xilinx-2024.1)

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
Call setup.sh again now, if no workspace folder is setup, it will return without giving a prompt.
```
$ ./setup.sh

Preparing docker images - please re-run this script to enter the container image!
setting up workspace
READY.
```

## Usage

```
$ ./setup.sh
setting environment
PATH=/tools/Xilinx/Vitis_HLS/2024.2/bin:/tools/Xilinx/Model_Composer/2024.2/bin:/tools/Xilinx/Vitis/2024.2/bin:/tools/Xilinx/Vitis/2024.2/gnu/microblaze/lin/bin:/tools/Xilinx/Vitis/2024.2/gnu/microblaze/linux_toolchain/lin64_le/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch64/lin/aarch64-linux/bin:/tools/Xilinx/Vitis/2024.2/gnu/aarch64/lin/aarch64-none/bin:/tools/Xilinx/Vitis/2024.2/gnu/armr5/lin/gcc-arm-none-eabi/bin:/tools/Xilinx/Vitis/2024.2/aietools/bin:/tools/Xilinx/Vitis/2024.2/gnu/riscv/lin/riscv64-unknown-elf/bin:/tools/Xilinx/Vivado/2024.2/bin:/tools/Xilinx/DocNav:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

xilinx<20:15:21>::lrub("~/");
(docker)$ vivado &
    ...
```
end a container session  
```
(docker)$ exit
$
```
A folder _workspace_ is mounted into the docker container. Content in the _workspace_ folder thus remains when exiting the container. What is in the container or installed during runtime is gone after exit.

## Troubleshooting

remove the container entirely
```
$ docker images
REPOSITORY                TAG            IMAGE ID       CREATED             SIZE
vivado-2024.2             202505031615   ca2385dc11ab   About an hour ago   174GB
ubuntu                    22.04          c6b84b685f35   20 months ago       77.8MB

$ docker rmi -f ca2385dc11ab
Untagged: vivado-2024.2:202505031615
Deleted: sha256:ca2385dc11ab1af2a4911ac13f0ce517edd2d720aecd815e6245a582c287e550

$ docker system prune -f
...
```

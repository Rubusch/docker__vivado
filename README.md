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


Download the installer from the official page.  
```
$ mkdir ./download
$ cp <Downloads>/FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin ./download
```

Check if UID and GID are in your environment. If not, set them accordingly.
```
$ export UID=$(id -u)
$ export GID=$(id -g)
```

Provide Xilinx user credentials as env vars.
```
$ export XILINXMAIL=my.email@company.com
$ export XILINXLOGIN='password123'
```
NB: `XILINXMAIL` and `XILINXLOGIN` are only needed for container creation. They are not stored inside the container.  

Edit the `install_config.txt` or use it as is, this is the Xilinx install config.  

After building the image, the folder `download` can be removed, the Xilinx installer .bin file can be found in `./docker/build_context` and can be equally removed.  

## Build

```
$ ./setup.sh
```

Initially call to setup.sh to setup a mounted folder workspace (if not already around), it will return without giving a prompt.
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
    ...

xilinx<20:15:21>::lrub("~/");
(docker)$ vivado &
    ...
```
end a container session  
```
(docker)$ exit
$
```
A folder _workspace_ is mounted into the docker container. Content in the _workspace_ folder thus persists when exiting the container.  
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

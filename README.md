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
$ echo "export UID=$(id -u)" > ./download/env
$ echo "export GID=$(id -g)" >> ./download/env
$ vi ./download/env
    ...
    export XILINXMAIL='<my email>'
    export XILINXLOGIN='<my xilinx password>'
```
NB: XILINXMAIL and XILINXLOGIN are only needed for container creation. They are not stored inside the container. The entries can be removed from the env file after installation! The env is not tracked by git.  

Example:  
```
$ tree -a ./download/
    ./download/
    ├── env
    ├── petalinux-*-installer.run
    └── Xilinx_Unified_*_Lin64.bin

    0 directories, 3 files

$ cat ./download/env
    export UID=105601750
    export GID=105600513
    export XILINXMAIL=my.email@company.com
    export XILINXLOGIN='password123'
```
After building the image, the folder `download` can be removed. The installer files will be in the respective `build_context` folders and can be equally removed.

## Build

```
$ source ./download/env
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

## Issues

TL;DR: The container (AMD 2023.1 installer) might work on recent systems.  

For the AMD/Xilinx installer to work, it looks like the host system should have a systemd older than v258 with corresponding kernel. The problem is related to the java codes used by tool `xsetup` for vivado installation. They seem to use the deprecated cgroup v1. If the up-to-date control group v2 is in place, this docker container build process will stop at executing script `./210-*`.  

Check the system: if no entry "memory" is around, you're using the up-to-date control group v2 (this container won't build).  
```
$ cat /proc/cgroups
    ...
    memory ...
    ...
```

There is a documented fix, supposed to work only up until systemd v258 (i.e. before), to provide a kernel boot argument. In this case, do the following on the host system. Append `XXX SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1 systemd.unified_cgroup_hierarchy=0` to the CMDLINE, keeping what was there before.  
```
$ sudo vi /etc/default/grub
    ...
    GRUB_CMDLINE_LINUX_DEFAULT="... SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1 systemd.unified_cgroup_hierarchy=0"
    ...
```
...then do...
```
$ sudo grub-update
```
...reboot and hope.  

For other, more recent systems, AMD does not provide a fixed installer to my knowledge, and systemd does not provide direct tweaks to mess up security for such installers. Since docker as technology is based on kernel shares and cgroups, this is a limiting factor here.  

references:  
- https://stackoverflow.com/questions/71532170/java-lang-nullpointerexception-cannot-invoke-jdk-internal-platform-cgroupinfo
- https://wiki.archlinux.org/title/Cgroups#Enable_cgroup_v1


[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

## Requirements
Ensure the following before proceeding:
- Download the `FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin` file
- A Xilinx account (typically free) is required to install the packages and provide login credentials
- Have `docker` installed
- This setup builds under Linux

## Build
Download the installer from the official page.  
```
$ mkdir ./download
$ cp <Downloads>/FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin ./download
$ cp <Downloads>/petalinux-*-installer.run ./download
```

Provide Xilinx user credentials as env vars for the build session.  
```
$ export XILINXMAIL=my.email@company.com
$ export XILINXLOGIN='password123'
```
Note: `XILINXMAIL` and `XILINXLOGIN` are required only during container creation and are not stored inside the container.  

In case edit the `install_config.txt` file, or use it as-is with a given default.  
```
$ ./setup.sh
```

## Usage
```
$ ./setup.sh
(docker)$ vivado &
```

End a container session
```
(docker)$ exit
$
```

The directory _workspace_ is mounted into the docker container. Content in the _workspace_ folder thus persists when exiting the container.  

The file ./docker/configs/.petalinux-sys.env can be used to register a license server or environment variables. The content of ./docker/configs is copied into the container dynamically, the container image does not need
to be rebuilt.  

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

## Requirements
Ensure the following before proceeding:
- Either download the full installer (SFP) file, or
- Download the `FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin` file
- A Xilinx account (typically free) is required to install the packages and provide login credentials
- Have `docker` installed
- This setup builds under Linux

## Build
Download your installer (web or full) from the official page, and place it in a directory `download`.  
Note the web installer is a `*_Lin64.bin`, the full installer is a `*.tar.gz` file.  
```
$ mkdir ./download
$ cp <Downloads>/FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin ./download
$ cp <Downloads>/petalinux-*-installer.run ./download
```

When using the full installer, that's it. For the web installer, provide Xilinx user credentials as env vars for the build session.  
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
```

Start tools
```
(docker)$ vivado &
```
or
```
(docker)$ xsct
```
or
```
(docker)$ xsdb
```

End a container session  
```
(docker)$ exit
$
```

The directory _workspace_ is mounted into the docker container. Content in the _workspace_ folder thus persists when exiting the container.  

The file ./docker/configs/.petalinux-sys.env can be used to register a license server or environment variables. The content of ./docker/configs is copied into the container dynamically, the container image does not need
to be rebuilt.  

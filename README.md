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

## Notes
When building older Yocto Project releases (such as 2024.1/2 w/ yocto Scarthgap)
inside a Docker container running on a modern host Linux distribution
(e.g., Ubuntu 24.04, Debian 13, or newer rolling updates), builds
frequently crash during the packaging phase (`do_package` tasks) with
variations of the following signature:
- "got *at() syscall for unknown directory, fd 4"
- "tar: ./usr/share: Cannot mkdir: Bad address"

ROOT CAUSE:
1. Security Patch Evolution (CVE-2025-45582):
   In early 2026, Linux distributions rolled out critical security upgrades for
   core host utilities like `tar` to prevent directory traversal vulnerabilities.
   To achieve this safely, modern host utilities now strictly utilize the modern
   Linux kernel system call **`openat2()`** rather than legacy calls (`openat()`, `mkdirat()`).

2. Pseudo's Interception Blinders:
   Yocto utilizes a utility called `pseudo` during its image creation workflows.
   `pseudo` intercepts file system tracking calls via `LD_PRELOAD` to simulate a
   virtual root filesystem layer (fakeroot) so file system attributes (like `chown root`)
   record correctly, even when building as a standard unprivileged user.

   Because older versions of Yocto (built prior to 2026) ship with an older `pseudo`
   engine, **`pseudo` had no code handling the new `openat2()` system call.**
   When host `tar` fired `openat2()`, `pseudo` missed the operation completely,
   lost track of the internal folder structures / file descriptors (`fd 4`),
   and corrupted its tracking state, causing `tar` to halt with a "Bad address".

THE RESOLUTION PLAN / WHY TRACKING LATEST BRANCHES RESOLVES IT:
- Legacy Workarounds (DO NOT USE): Disabling `BB_SANDBOX` or forcing `PSEUDO_UNLOAD=1`
  causes major regressions. Turning off the sandbox globally breaks `chown` and
  `chmod` inside the rootfs because the unprivileged mapped container user account
  cannot execute real root system commands, leading to "Invalid argument" blocks.

- Clean Resolution: Upstream Yocto Maintainers backported a native solution
  directly into the `scarthgap` release tree. The `pseudo` engine source code
  was patched to naturally capture, parse, and process the modern `openat2()`
  system call parameters.

Generally replacing Xilinx's not updated poky by cloning the official poky seems to
fix this yocto build issue issue.

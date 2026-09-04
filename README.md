[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

## Requirements
Ensure the following before proceeding:
- Download the `FPGAs_AdaptiveSoCs_Unified_*_Lin64.bin` file
- A Xilinx account (typically free) is required to install the packages and provide login credentials
- Have `docker` installed
- This setup builds under Linux
- Note: The Xilinx Installer uses a JDK version which has known issues with the control group handling (see issues).
  Thus either use Ubuntu <= v24.04, or try to apply the described fix down below.

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

## Issues

TL;DR: The container (AMD 2023.1 installer) may fail with the following error. It worked on a Ubuntu 24.04 without showing this issue.  

```
71.59 spawn ./xsetup -b ConfigGen
71.70 This is a fresh install.
71.71 INFO Could not detect the display scale (hDPI).
71.71        If you are using a high resolution monitor, you can set the insaller scale factor like this:
71.71        export XINSTALLER_SCALE=2
71.71        setenv XINSTALLER_SCALE 2
71.71 Running in batch mode...
71.88 Exception in thread "main" java.lang.ExceptionInInitializerError
71.88   at com.xilinx.installer.api.InstallerLauncher.<clinit>(Unknown Source)
71.88 Caused by: java.lang.NullPointerException: Cannot invoke "jdk.internal.platform.CgroupInfo.getMountPoint()" because "anyController" is null
71.88   at java.base/jdk.internal.platform.cgroupv2.CgroupV2Subsystem.getInstance(CgroupV2Subsystem.java:80)
71.88   at java.base/jdk.internal.platform.CgroupSubsystemFactory.create(CgroupSubsystemFactory.java:114)
71.88   at java.base/jdk.internal.platform.CgroupMetrics.getInstance(CgroupMetrics.java:177)
71.88   at java.base/jdk.internal.platform.SystemMetrics.instance(SystemMetrics.java:29)
71.88   at java.base/jdk.internal.platform.Metrics.systemMetrics(Metrics.java:58)
71.88   at java.base/jdk.internal.platform.Container.metrics(Container.java:43)
71.88   at jdk.management/com.sun.management.internal.OperatingSystemImpl.<init>(OperatingSystemImpl.java:182)
71.88   at jdk.management/com.sun.management.internal.PlatformMBeanProviderImpl.getOperatingSystemMXBean(PlatformMBeanProviderImpl.java:280)
71.88   at jdk.management/com.sun.management.internal.PlatformMBeanProviderImpl$3.nameToMBeanMap(PlatformMBeanProviderImpl.java:199)
71.88   at java.management/sun.management.spi.PlatformMBeanProvider$PlatformComponent.getMBeans(PlatformMBeanProvider.java:195)
71.88   at java.management/java.lang.management.ManagementFactory.getPlatformMXBean(ManagementFactory.java:687)
71.88   at java.management/java.lang.management.ManagementFactory.getOperatingSystemMXBean(ManagementFactory.java:389)
71.88   at com.xilinx.installer.utils.s.<clinit>(Unknown Source)
71.88   ... 1 more
```
For the AMD/Xilinx installer to work, it looks like the host system should have a systemd older than v258 with corresponding kernel. The problem is related to the java codes used by tool `xsetup` for vivado installation. They sem to use the deprecated cgroup v1. If the up-to-date control group v2 is in place.  

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

For other, more recent systems, AMD does not provide a fixed installer to my knowledge, and systemd does not provide direct tweaks to mess up security for such installers. Since docker as technology is based on kernel
shares and cgroups, this is a limiting factor here.  

references:
- https://stackoverflow.com/questions/71532170/java-lang-nullpointerexception-cannot-invoke-jdk-internal-platform-cgroupinfo
- https://wiki.archlinux.org/title/Cgroups#Enable_cgroup_v1

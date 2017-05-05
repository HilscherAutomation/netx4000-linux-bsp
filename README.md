# Introduction
netX4000 Linux BSP repository is a collection of build scripts and git submodules required to build a running linux image for the Hilscher netX4000 SoC.

It contains:
- yocto build system to build your own images / distributions (https://www.yoctoproject.org)
- ubuntu root filesystem build using debootstrap to build ubuntu installable images

It is strongly recommended to use docker for building, as it contains a well-defined build environment. This documentation only describes building images using docker.

Building has been tested with docker v17.03.1-ce on the following host system distributions:
- Ubuntu 16.04 LTS (xenial)
- FedoraCore25
- CentOS 7

For docker installation instructions see https://www.docker.com/community-edition#/download


Native building using your installed linux distribution is also possible by passing `--native` as first argument to main build scripts, but will require you to install all required packages on your host system manually. Native building may cause issues / incompatibilities with the used tools (e.g. yocto/poky) which may not be easily solvable or not solvable at all. It is neither recommended nor described in this document.


Base for all projects:

| Type | Name | Version |
|------|------|---------|
| Bootloader | Barebox | 2016.07.0 |
| Kernel | linux-stable | 4.9 |


# Yocto 2.2

For a full documentation of the Yocto build system refer to http://www.yoctoproject.org/docs/2.2.1/mega-manual/mega-manual.html


## Building

`./build_yocto.sh`
Results and build artefacts are located in subfolders of yocto/build/tmp/deploy. The default image being generated is core-image-minimal.


### Build different image or individual packages

To build a custom image execute the build script with an additional image name.
`./build_yocto.sh core-image-sato`

Commonly used images in yocto:

| Name | Description |
|------|-------------|
| core-image-minimal | A small image just capable of allowing a device to boot |
| core-image-minimal-dev | A small image just capable of allowing a device to boot and is suitable for development work |
| core-image-sato | Image with Sato, a mobile environment and visual style for mobile devices |
| core-image-sato-dev | Image with Sato, a mobile environment and visual style for mobile devices plus a native toolchain, application development |
| core-image-x11 | A very basic X11 image with a terminal |

## Modify configuration

### Bootloader
`./build_yocto.sh barebox -c menuconfig`

This will open up a ncurses based configuration for barebox.

### Kernel
`./build_yocto.sh virtual/kernel -c menuconfig`

This will open up a ncurses based configuration for linux.

### Yocto
Yocto allows overriding global parameters in a file called local.conf located in *yocto/build/conf/local.conf*.

Most common uses are
* Add additional packages to images without requiring to change yocto layers / recipes
* Switch target machine / board

#### Add additional packages
To add packages to **all** produced images you will need to list them in a variable called IMAGE_INSTALL by adding them via `IMAGE_INSTALL_append += "<package>"`. To get a list of available recipes, contained in .bb files, search all layers for files with the extension `.bb`.

Example:
```
# Add wget and git to image
IMAGE_INSTALL_append += "wget git"

# Also add strace
IMAGE_INSTALL_append += "strace"
```

Refer to yocto documentation for all available options.

**NOTE:** If a package is not available you will either need to find a layer that includes the required package as recipe, or write an own layer including this package recipe.


#### Add additional layers
Layers provide additional features and packages and must be introduced to yocto by adding them to bblayers.conf file located in *yocto/build/conf/bblayers.conf*.

A list of available layers can be found at https://layers.openembedded.org/layerindex/branch/master/layers

Usually openembedded layer is included in larger projects (https://github.com/openembedded/meta-openembedded)

You will need to clone or copy an existing layer to your hard disk and add a reference to *bblayers.conf*

**shell:**
```
cd yocto
git clone -b morty https://github.com/openembedded/meta-openembedded
```

**bblayers.conf:**
```
# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \
  /build/poky/meta \
  /build/poky/meta-poky \
  /build/meta-oe/meta-oe \
  /build/poky/../meta-hilscher-netx4000"
```

## Prepare SD card for booting

To boot netX4000 based boards (NXHX4000-JTAG) it is recommended to use a SD/MMC card that contains 2 partitions:

| Nr | Type | Size | Description |
|----|------|------|-------------|
| 1  | FAT  | ~64MB | Contains bareboox bootloader (may also contain kernel) |
| 2  | EXT4 | depends on image <br /> core-image-minimal ~20MB <br/> (automatically determined by build system) | Contains root file system |

The yocto recipe creates an image file that can directly be written to a SD/MMC card, without requiring to previously partition the sdcard, as follows:
```
cd yocto/build/tmp/deploy/images/nxhx4000-jtag-plus_rev2
dd if=core-image-minimal-nxhx4000-jtag-plus_rev2.sdimg of=/dev/sdb
sync
```
**NOTE:** 
- /dev/sdb is the device file of SD card and must be adapted to your conditions!
- root permissions (sudo) are required


# Ubuntu 16.04 LTS

This BSP contains a script that uses Ubuntu's *gcc-arm-linux-gnueabihf* package to build:
- barebox bootloader
- linux kernel

It also uses qemu and debootstrap to generate an ubuntu root file system for armhf architecture.
Per default this root file system is based on *ubuntu-standard* meta package.

## Building

You just need to call the supplied build script:
`./build_ubuntu.sh`

The resulting build artefacts can be found in *ubuntu/build/* folder.

## Configuration

The supplied default configuration works out of the box, but in case you want do include different options
into kernel or barebox you can call the supplied script to change the default configuration

### Barebox
`./build_ubuntu.sh barebox menuconfig`

### Kernel
`./build_ubuntu.sh kernel menuconfig`

## Prepare SD card for booting

To boot netX4000 based boards (NXHX4000-JTAG) it is recommended to use a SD/MMC card that contains 2 partitions:

| Nr | Type | Size | Description |
|----|------|------|-------------|
| 1  | FAT  | ~64MB | Contains bareboox bootloader |
| 2  | EXT4 | 2GB (default) | Contains root file system |

The ubuntu script creates an image file that can directly be written to a SD/MMC card, without requiring to previously partition the sdcard, as follows:
```
cd ubuntu/build
dd if=netx4000-ubuntu-nxhx4000-jtag-plus_rev2.sdimg of=/dev/sdb
sync
```
**NOTE:**
- /dev/sdb is the device file of SD card and must be adapted to your conditions!
- root permissions (sudo) are required



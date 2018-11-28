This README file contains usage information for the netX4000 Linux board support package

# Table of Contents
1. Description
2. Initialization
   1. Install repo
   2. Initialize workspace
   3. Fetch sources
3. Building
   1. Building yocto images
   2. Building ubuntu images

# 1. Description
This BSP uses androids repo tool to pull in all required repositories. It supports the following
yocto releases:
 - master
 - sumo (2.5)
 - rocko (2.4)

# 2. Initialization

## 2.1 Install repo
Install the android repo tool:
https://source.android.com/setup/develop/
```
  mkdir ~/bin
  export PATH=~/bin:$PATH
  curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
  chmod a+x ~/bin/repo
```

## 2.2 Initialize workspace
Create a working directory and initialize repo tool for your requested yocto version. The following
example will use the master branch
```
mkdir ~/workspace/netx4000
cd ~/workspace/netx4000
repo init -u https://github.com/Hilscher/netx4000-linux-bsp -m master.xml
```

## 2.3 Fetch sources
Let repo fetch all requires sources. Updates can also be pulled this way

`repo sync`


# 3 Building
Recommended way of building is using docker as this is includes all required packages in tested versions.

## 3.1 Build yocto images
Use the supplied scripts to build a machine. The machine can be switch after first build by editing build/conf/local.conf

`./build_docker.sh core-image-minimal`

Copy the resulting image to an sdcard and insert it into your board:
`dd if=build/tmp/deploy/images/<machine>/<image>_<machine>.sdimg of=/dev/sdb`

## 3.2 Build ubuntu images
**NOTE:** Ubuntu images are only provided for evaluation purposes and are not fully validated

To select a different kernel / machine, edit ubuntu.cfg

```
cd meta-hilscher-netx4000/scripts/ubuntu
 ./build_docker.sh
```

Copy the resulting image to an sdcard:
`dd if=build/netx4000-ubuntu-18.04-<machine>.sdimg of=/dev/sdb`

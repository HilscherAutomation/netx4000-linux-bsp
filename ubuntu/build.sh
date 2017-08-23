#!/bin/bash -e

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

default_device_tree="nxhx4000-jtag-plus-rev3"

default_barebox_args=""
default_kernel="zImage"
default_kernel_pkg_args="--arch $ARCH --subarch armhf --cross-compile $CROSS_COMPILE --jobs 4 --revision=0.9 --us --uc --rootcmd fakeroot kernel_image kernel_headers"
default_rootfs_args=""
default_sdimg_args="$default_device_tree"

if [ -e ./ubuntu.cfg ]; then
	echo Overwriting default parameter ...
	cat ./ubuntu.cfg
	source ./ubuntu.cfg
fi

do_build_barebox() {
	echo "Building bootloader"

	# Barebox destination
	export BAREBOX_DEST=$(pwd)/build/barebox

	pushd netx4000-barebox

	# Create default config if neccessary
	if [ ! -e .config ]; then
		make netx4000_defconfig

		# Select correct machine device tree file
		sed -i -e "s,\(CONFIG_BUILTIN_DTB_NAME=\).*,\1\"${default_device_tree}\",g" .config
	fi

	make ${@:-${default_barebox_args}}

	if [ "$*" == "clean" ]; then
		rm -f barebox.netx4000
	fi

	if [ -e barebox.netx4000 ]; then
		mkdir -p ${BAREBOX_DEST}
		cp barebox.netx4000 ${BAREBOX_DEST}/netx.rom
	fi

	popd
}

do_build_kernel() {
	echo "Building kernel package"

	# Kernel destination
	export KERNEL_DEST=$(pwd)/build/kernel

	pushd netx4000-linux

	# Create default config if neccessary
	if [ ! -e .config ]; then
		make netx4000_defconfig
	fi

	if [ $@ ]; then
		make $@
	else
		make-kpkg $default_kernel_pkg_args
		mkdir -p ${KERNEL_DEST}
		rm -f ${KERNEL_DEST}/*.deb
		mv ../*.deb ${KERNEL_DEST}
	fi

	popd
}

do_create_rootfs() {
	pushd build
	sudo ../build_rootfs.sh ${@:-${default_rootfs_args}}
	popd
}

do_create_sdimg() {
	pushd build
	sudo ../build_sdimg.sh  ${@:-${default_sdimg_args}}
	popd
}

case $1 in
	barebox)
		shift
		do_build_barebox $@
		;;
	kernel)
		shift
		do_build_kernel $@
		;;
	rootfs)
		shift
		do_create_rootfs $@
		;;
	sdimg)
		shift
		do_create_sdimg $@
		;;
	*)
		do_build_barebox
		do_build_kernel
		do_create_rootfs
		do_create_sdimg
		;;
esac

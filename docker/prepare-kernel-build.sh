#!/usr/bin/env bash


bundleDir="build-kernel/linux"

mkdir -p build-kernel/linux

# Copy kernel packages to container build environment
if [ ! -f ${bundleDir}/.helper ]; then
	cp ../packages/manual/.helper build-kernel/linux/
fi

if [ ! -f ${bundleDir}/LINUX-VERSION ]; then
	cp ../packages/manual/LINUX-VERSION build-kernel/linux/
fi

if [ ! -f ${bundleDir}/.kernel-helper ]; then
	cp ../packages/manual/.kernel-helper build-kernel/linux/
fi

if [ ! -f ${bundleDir}/.download_all_kernel_sources.sh ]; then
	cp ../packages/manual/download_all_kernel_sources.sh build-kernel/linux/
fi

if [[ ! -d ${bundleDir}/linux-5.10.d/ ]]; then
	# just Copy everything matching linux-* again if the folder is not present
	cp -r ../packages/manual/linux-* build-kernel/linux/
fi


if [[ ! -d ${bundleDir}/cert/ ]]; then
	cp -r ../cert build-kernel/cert/
fi


cd build-kernel/

# Set Linux Version env variables
. linux/LINUX-VERSION && ./linux/download_all_kernel_sources.sh

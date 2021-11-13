#!/usr/bin/env bash



bundleDir="build-kernel/linux"

mkdir -p build-kernel/linux

. ${bundleDir}/LINUX-VERSION
. ${bundleDir}/.helper
. ${bundleDir}/.kernel-helper

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

if [[ ! -d ${bundleDir}/linux-5.10.d/ ]]; then
	# just Copy everything matching linux-* again if the folder is not present
	cp -r ../packages/manual/linux-* build-kernel/linux/
fi


if [[ ! -d ${bundleDir}/cert/ ]]; then
	cp -r ../cert build-kernel/cert/
fi


cd build-kernel/




get_kernel_sources 

get_debian_release_env

get_old_kernel

get_ufs5_from_upstream

get_linux_stable_for_comments







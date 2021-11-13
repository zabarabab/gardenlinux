#!/usr/bin/env bash

print_help() {
      echo "options:"
      echo "-h, --help			show brief help"
      echo "-d, --debug			debug mode of this script"
      echo "-k, --keepold		do not copy kernel scripts again from packages (for debugging)"	
      echo "-o, --output-dir=DIR	specify where to place the kernel source bundle"

}

while test $# -gt 0; do
  case "$1" in
	-h|--help)
		print_help
		exit 0
	;;
	-d|--debug)
		shift
      		debug=1
	;;
	--keepold) 
		keepold=0	# Do not copy kernel scripts again (for debugging)  
	;;
	-o|--output-dir*)
		outputDir=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *) print_help
      break
      ;;
  esac
done


if [ ${debug:-} ]; then
	set -x
fi


bundleDir=${bundleDir:-"build-kernel/linux"}
keepold=${keepold:-0}
mkdir -p build-kernel/linux


# Copy kernel packages to container build environment
if [ ! -f ${bundleDir}/.helper ] && [ ${keepold} == 0 ]; then
	cp ../packages/manual/.helper build-kernel/linux/
fi

if [ ! -f ${bundleDir}/LINUX-VERSION ] && [ ${keepold} == 0 ]; then
	cp ../packages/manual/LINUX-VERSION build-kernel/linux/
fi

if [ ! -f ${bundleDir}/.kernel-helper ] && [ ${keepold} == 0 ]; then
	cp ../packages/manual/.kernel-helper build-kernel/linux/
fi

if [[ ! -d ${bundleDir}/linux-5.10.d/ ]]; then
	# just Copy everything matching linux-* again if the folder is not present
	cp -r ../packages/manual/linux-* build-kernel/linux/
fi


if [[ ! -d ${bundleDir}/cert/ ]]; then
	cp -r ../cert build-kernel/cert/
fi


. ${bundleDir}/LINUX-VERSION
. ${bundleDir}/.helper
. ${bundleDir}/.kernel-helper

cd build-kernel/

#gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org 514B0EDE3C387F944FB3799329E574109AEBFAAA
#gpg --import cert/sign.pub > /dev/null

import_gpg_keys

get_kernel_sources 

get_debian_release_env

get_old_kernel

get_ufs5_from_upstream

get_linux_stable_for_comments







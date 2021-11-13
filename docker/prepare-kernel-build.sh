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
		keepold=1	# Do not copy kernel scripts again (for debugging)  
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
if [ ! -f ${bundleDir}/.helper ] || [ ${keepold} == 0 ]; then
	echo "Getting fresh helper"
	cp ../packages/manual/.helper ${bundleDir}
fi

if [ ! -f ${bundleDir}/LINUX-VERSION ] || [ ${keepold} == 0 ]; then
	echo "Getting fresh LINUX-VERSION"
	cp ../packages/manual/LINUX-VERSION ${bundleDir} 
fi

if [ ! -f ${bundleDir}/gpgkeys ] || [ ${keepold} == 0 ]; then
	echo "Getting fresh gpgkeys"
	cp ../packages/manual/linux-5.10.d/gpgkeys ${bundleDir}
fi

if [ ! -f ${bundleDir}/.kernel-helper ] || [ ${keepold} == 0 ]; then
	echo "Getting fresh kernel-helper"
	cp ../packages/manual/.kernel-helper ${bundleDir}
fi

if [[ ! -d ${bundleDir}/linux-5.10.d/ ]]; then
	# just Copy everything matching linux-* again if the folder is not present
	cp -r ../packages/manual/linux-* ${bundleDir}
fi


if [[ ! -d ${bundleDir}/cert/ ]]; then
	cp -r ../cert ${bundleDir}
fi


. ${bundleDir}/LINUX-VERSION
. ${bundleDir}/.helper
. ${bundleDir}/.kernel-helper


#gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org 514B0EDE3C387F944FB3799329E574109AEBFAAA
#gpg --import cert/sign.pub > /dev/null

echo "--------------------------"
import_gpg_keys ${bundleDir} ${bundleDir}/gpgkeys
#${bundleDir}/gpgkeys

get_kernel_sources ${bundleDir}

get_debian_release_env ${bundleDir}

get_old_kernel ${bundleDir}

get_ufs5_from_upstream ${bundleDir}

get_linux_stable_for_comments ${bundleDir}






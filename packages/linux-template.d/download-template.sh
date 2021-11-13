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

thisDir=$(dirname $0)
kernelSrcDir=${kernelSrcDir:-"${thisDir}/gardenkernel-src"}
keepold=${keepold:-0}
mkdir -p ${kernelSrcDir}

. ${thisDir}/LINUX-VERSION
. ${thisDir}/.kernel-helper


#gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org 514B0EDE3C387F944FB3799329E574109AEBFAAA
#gpg --import cert/sign.pub > /dev/null

echo "--------------------------"
import_gpg_keys ${kernelSrcDir} ${thisDir}/gpgkeys

get_kernel_sources ${kernelSrcDir}

get_debian_release_env ${kernelSrcDir}

get_old_kernel ${kernelSrcDir}

get_ufs5_from_upstream ${kernelSrcDir}

get_linux_stable_for_comments ${kernelSrcDir}






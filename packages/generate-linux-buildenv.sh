#!/usr/bin/env bash

print_help() {
      echo "options:"
      echo "-h, --help			show brief help"
      echo "-d, --debug			debug mode of this script"
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
	-t|--template-input*)
		templateDir=`echo $1 | sed -e 's/^[^=]*=//g'`
 		shift
      	;;
	-o|--output-dir*)
		outputDir=`echo $1 | sed -e 's/^[^=]*=//g'`
 		shift
      	;;
	-v|--version-file*)
		versionFile=`echo $1 | sed -e 's/^[^=]*=//g'`
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

if [[ ! -d ${templateDir} ]]; then echo "templateDir=${templateDir} does not exist"; return 1; fi
if [[ ! -d ${outputDir} ]]; then echo "outputDir=${outputDir} does not exist"; return 1; fi
if [ ! -f ${versionFile} ]; then echo "versionFile=${versionFile} does not exist"; return 1; fi

. ${versionFile}

# copy template dir
mkdir ${outputDir}/linux-${KERNEL_VERSION}.d
cp ${templateDir}/* ${outputDir}/linux-${KERNEL_VERSION}.d

rename  's/template/${KERNEL_VERSION}/' *


popd ${outputDir}/linux-${KERNEL_VERSION}.d








pushd

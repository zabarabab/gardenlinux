#!/usr/bin/env bash
set -o pipefail
print_help() {
      echo "options:"
      echo "-h, --help			show brief help"
      echo "-d, --debug			debug mode of this script"
      echo "-k, --keep-sources		for development. does not delete previous downloaded kernel sources"
      echo "-o, --output-dir DIR	specify where to place the generated files"
      echo "-t, --template-dir DIR	path to template directory to use as base"
      echo "-v, --version-file FILE 	path to env file specifying VERSIONS"	
}

keepSrc=0
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
	-k|--keep-sources)
		keepSrc=1
 		shift
      	;;
	-t|--template-dir*)
		#templateDir=`echo $1 | sed -e 's/^[^=]*=//g'`
		templateDir=$2
		echo "set templateDir=${templateDir} "
 		shift; shift
      	;;
	-o|--output-dir*)
		outputDir=$2
		echo "set outputDir=${outputDir} "
 		shift; shift
      	;;
	-v|--version-file*)
		versionFile=$2
		echo "set versionFile=${versionFile} "
 		shift; shift
      	;;
    *)
      break
      ;;
  esac
done

if [ ${debug:-} ]; then
	set -x
fi

if [ -z ${templateDir+x} ]; then echo "template-dir not specified"; print_help;  exit 1; fi 
if [ -z ${outputDir+x} ]; then echo "output-dir not specified"; print_help;  exit 1; fi 
if [ -z ${versionFile+x} ]; then echo "version-file not specified"; print_help;  exit 1; fi 

if [[ ! -d ${templateDir} ]]; then echo "templateDir=${templateDir} does not exist"; exit 1; fi
if [[ ! -d ${outputDir} ]]; then echo "outputDir=${outputDir} did not exist"; mkdir ${outputDir}; fi
if [ ! -f ${versionFile} ]; then echo "versionFile=${versionFile} does not exist"; exit 1; fi

. ${versionFile}

# create a copy from template dir

if [ ${keepSrc} == 0 ]; then rm -rf ${outputDir}/linux-${KERNEL_VERSION}.d ;fi
mkdir -p ${outputDir}/linux-${KERNEL_VERSION}.d
mkdir -p ${outputDir}/linux-${KERNEL_VERSION}.d/patches
cp -r ${templateDir}/* ${outputDir}/linux-${KERNEL_VERSION}.d
cp ${templateDir}/.kernel-helper ${outputDir}/linux-${KERNEL_VERSION}.d
cp ${versionFile} ${outputDir}/linux-${KERNEL_VERSION}.d

cp gardenkernel-patches/${KERNEL_VERSION}/* ${outputDir}/linux-${KERNEL_VERSION}.d/patches/

pushd ${outputDir}


pushd linux-${KERNEL_VERSION}.d

# rename templated files
listTemplate=$(ls | grep 'template')
echo $listTemplate
for f in ${listTemplate}; do mv "$f" "$(echo "$f" | sed s/template/${KERNEL_VERSION}/)"; done

mv linux-${KERNEL_VERSION} ..
mv linux-${KERNEL_VERSION}-signed ..
popd
popd

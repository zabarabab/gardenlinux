#!/usr/bin/env bash


# Check if kernel Version is available
if [ -z ${1+x} ]; then echo "First argument of ${FUNCNAME[0]} must be path to linux-KERNEL_VERSION.d dir"; exit 1;fi 

baseDir=$1						# linux-version.d
. ${baseDir}/LINUX-VERSION

bundleDir="${baseDir}/gardenkernel-src"			# contains downloaded sources
releaseEnvDir="${bundleDir}/linux-release-env"		# the debian release env

if [ -z ${KERNEL_VERSION+x} ]; then echo "KERNEL_VERSION is unset"; exit 1; else echo "KERNEL_VERSION is set to '${KERNEL_VERSION}'"; fi

patchDir=${baseDir}/patches

echo "### patching Garden Linux enhancements"

echo ${patchDir}
echo ${baseDir}
pushd ${releaseEnvDir}
#patch -p1 < $baseDir/rt-0038.patch
cp ${patchDir}/fpga-ofs.patch ${releaseEnvDir}/debian/patches

patch -p1 < ${patchDir}/fpga-config.patch
printf "\n# Intel IOFS patches\nfpga-ofs.patch\n" >> debian/series
CHANGELOG+="  * Added Intel FPGA OFS\n"
#patch -p1 < $baseDir/mok.patch
#patch -p1 < $baseDir/series.patch

popd

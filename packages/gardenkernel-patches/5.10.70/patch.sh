#!/usr/bin env bash


# Check if kernel Version is available
if [ -z ${KERNEL_VERSION+x} ]; then echo "KERNEL_VERSION is unset"; return 1; else echo "KERNEL_VERSION is set to '${KERNEL_VERSION}'"; fi
if [ -z ${1+x} ]; then echo "First argument of ${FUNCNAME[0]} must be path to linux-${KERNEL_VERSION}.d dir"; return 1;fi 
bundleDir=$1
patchDir=${bundleDir}/patches


echo "### patching Garden Linux enhancements"
pushd bundleDir
#patch -p1 < $baseDir/rt-0038.patch
cp $patchDir/fpga-ofs.patch debian/patches
patch -p1 < $patchDir/fpga-config.patch
printf "\n# Intel IOFS patches\nfpga-ofs.patch\n" >> debian/series
CHANGELOG+="  * Added Intel FPGA OFS\n"
#patch -p1 < $baseDir/mok.patch
#patch -p1 < $baseDir/series.patch

popd

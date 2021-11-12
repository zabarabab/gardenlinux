#!/usr/bin/env bash
set -euox pipefail

. $(dirname $0)/.helper
. $(dirname $0)/.kernel-helper
. $(dirname $0)/LINUX-VERSION

get_kernel_sources 

get_debian_release_env

get_old_kernel

get_ufs5_from_upstream

get_linux_stable_for_comments


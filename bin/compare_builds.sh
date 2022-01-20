#!/bin/bash
set -Eeuo pipefail

build_0="$1"
build_1="$2"

for f in "$build_0"/*; do basename "$f"; done \
| while read f; do
	printf "%-64s" "$f"
	hash_0=$(sha256sum "$build_0/$f/rootfs.raw" | cut -c -64)
	hash_1=$(sha256sum "$build_1/$f/rootfs.raw" | cut -c -64)
	if [ "$hash_0" = "$hash_1" ]; then
		echo ok
	else
		echo error
		exit 1
	fi
  done

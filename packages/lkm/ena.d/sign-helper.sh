#!/bin/sh

echo "signing $2 for $1"
/usr/lib/linux-kbuild-5.10/scripts/sign-file sha512 /kernel.key /kernel.crt $2


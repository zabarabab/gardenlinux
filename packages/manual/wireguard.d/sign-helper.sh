#!/bin/sh

echo "signing $2"
/usr/lib/linux-kbuild-5.10/scripts/sign-file sha512 /kernel.key /kernel.crt $2


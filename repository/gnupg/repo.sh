#!/usr/bin/env bash
set -euo pipefail

BUILDNAME="GardenLinux Maintainers"
BUILDEMAIL="contact@gardenlinux.io"
BUILDKEY="contact@gardenlinux.io"
BUILDKEYPUB=$(gpg --armor --export "${BUILDKEY}") 
BUILDIMAGE="gardenlinux:build"
BUILDTARGET="$(readlink -f ../.packages)"

docker build -t aa .

# make sure the gpg agent is running
gpg-connect-agent /bye
gpg --armor --export "${BUILDKEY}" > gpg.key

docker run --rm \
	--volume ~/.gnupg:/root/.gnupg/ \
	--volume "$(gpgconf --list-dir agent-socket)":/root/xgnupg/S.gpg-agent \
	--volume $(pwd)/gpg.key:/root/gpg.key \
	-e GPG_TTY=/dev/console \
	-ti aa \
        bash 


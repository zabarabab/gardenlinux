ARG  build_base_image=gardenlinux/build
FROM	$build_base_image

ARG	DEBIAN_FRONTEND=noninteractive

RUN	sudo apt-get update \
     && sudo apt-get install -y \
		gnupg wget devscripts

COPY	linux /opt/linux
COPY	cert/sign.pub /sign.pub
COPY	cert/Kernel.sign.full /kernel.full
COPY	cert/Kernel.sign.crt /kernel.crt
COPY	cert/Kernel.sign.key /kernel.key




ENV	CERTDIR=/opt/cert
RUN	/opt/linux/linux-5.10



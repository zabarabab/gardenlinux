ARG  build_base_image=gardenlinux/build
FROM	$build_base_image

ARG	DEBIAN_FRONTEND=noninteractive

RUN	sudo apt-get update \
     && sudo apt-get install -y \
		gnupg wget devscripts

COPY	linux /opt/linux
COPY	cert /opt/cert


ENV	CERTDIR=/opt/cert
RUN	/opt/linux/linux-5.10



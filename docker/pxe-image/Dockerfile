ARG build_base_image=gardenlinux/slim
FROM 	$build_base_image
ARG	DEBIAN_FRONTEND=noninteractive

RUN	apt-get update \
     &&	apt-get install -y --no-install-recommends dnsmasq \ 
     &&	rm -rf /var/lib/apt/lists/*

ENV	PATH=${PATH}:/opt/gardenlinux/bin

WORKDIR	/tmp

ENTRYPOINT ["dnsmasq","-d"]

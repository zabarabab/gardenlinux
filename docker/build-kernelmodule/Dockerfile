ARG build_base_image=gardenlinux/build
FROM	$build_base_image

# Build Tools
RUN sudo apt-get update && \
    sudo apt-get install -y \
		libelf1 git vim build-essential dh-make devscripts dkms \
		rsync

# Required for Garden Linux linux-headers
COPY certs/ /certs
RUN sudo apt-key add /certs/gardenlinux.asc
RUN echo "deb http://repo.gardenlinux.io/gardenlinux 625.0 main" | sudo tee -a /etc/apt/sources.list

# Required for linux-kbuild dependency
RUN echo "deb http://deb.debian.org/debian bullseye main" | sudo tee -a /etc/apt/sources.list

# Required to build kernel modules for Garden Linux kernel
RUN sudo apt-get update && \
    sudo apt-get install -y \
	linux-kbuild-5.10 \
	linux-headers-5.10-cloud-amd64 \
	linux-headers-5.10-amd64


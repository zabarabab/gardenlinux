ARG build_base_image=gardenlinux/slim
FROM	$build_base_image

ARG	DEBIAN_FRONTEND=noninteractive

RUN	mkdir /etc/sudoers.d \
     &&	echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel \
     && echo "deb-src https://deb.debian.org/debian testing main" >> /etc/apt/sources.list \
     &&	echo "#deb https://deb.debian.org/debian unstable main" >> /etc/apt/sources.list \
     && echo "#deb-src https://deb.debian.org/debian unstable main" >> /etc/apt/sources.list \
     && echo "APT::Install-Recommends false;\nAPT::Install-Suggests false;\nApt::AutoRemove::SuggestsImportant false;\n" > /etc/apt/apt.conf.d/no-recommends \
     &&	echo "progress=bar:force:noscroll" >> /etc/wgetrc \
     &&	echo "force-confold\nforce-confdef" > /etc/dpkg/dpkg.cfg.d/forceold

RUN apt-get update && apt-get install -y wget ca-certificates build-essential binutils gcc gcc-10 devscripts fakeroot sudo git htop

ARG ARCH

RUN if [ "$ARCH" != "$(dpkg --print-architecture)" ]; then \
        dpkg --add-architecture $ARCH \
        && apt-get update \
        && LINUX_ARCH=$([ "$ARCH" = "arm64" ] && echo "aarch64-linux-gnu" || echo "x86-64-linux-gnu") \
        && apt-get install -y crossbuild-essential-$ARCH binutils-$LINUX_ARCH gcc-$LINUX_ARCH gcc-10-$LINUX_ARCH; \
    fi

RUN addgroup --system wheel \
    && adduser dev --disabled-password --gecos dev \
    && adduser dev wheel

COPY apt.patch /apt.patch
RUN cd $(mktemp -d) && apt-get build-dep -y apt && apt-get source apt && cd apt-* && patch -p1 < /apt.patch && dpkg-buildpackage -us -uc -ui && cd .. && dpkg -i *.deb

COPY install-cfssl.sh /setup/
RUN  /setup/install-cfssl.sh

USER	dev
WORKDIR	/home/dev

RUN 	mkdir .gnupg && chmod 700 .gnupg
RUN git config --global http.postBuffer $((256 * 1024 * 1024))

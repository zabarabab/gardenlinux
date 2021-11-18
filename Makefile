VERSION=`bin/garden-version`
IMAGE_BASENAME=garden-linux
PUBLIC=true
AWS_DISTRIBUTE=
BUILDDIR=.build
MAINTAINER_EMAIL="contact@gardenlinux.io"

ARCH ?= $(shell [ "$$(uname -m)" = "aarch64" ] && echo "arm64" || echo "amd64")

.PHONY: all all_dev all_prod
all: all_dev all_prod

cert/sign.pub:
	make --directory=cert MAINTAINER_EMAIL=$(MAINTAINER_EMAIL)
	@gpg --list-secret-keys $(MAINTAINER_EMAIL) > /dev/null || echo "No secret key for $(MAINTAINER_EMAIL) exists, signing disabled"
	@diff cert/sign.pub gardenlinux.pub || echo "Not using the official key"

.PHONY: container-build
container-build:
	make --directory=docker build-image

all_prod: ali aws gcp azure metal openstack vmware kvm

all_dev: ali-dev aws-dev gcp-dev azure-dev metal-dev openstack-dev vmware-dev kvm-dev

ALI_IMAGE_NAME=$(IMAGE_BASENAME)-ali-$(VERSION)
ali: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,ali $(BUILDDIR)/ali $(VERSION)

ali-upload:
	aliyun oss cp $(BUILDDIR)/ali-gardener-amd64-$(VERSION)-local/rootfs.qcow2  oss://gardenlinux-development/gardenlinux/$(ALI_IMAGE_NAME).qcow2

ALI_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-dev-ali-$(VERSION)
ali-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,ali,_dev $(BUILDDIR)/ali-dev $(VERSION)

ali-dev-upload:
	aliyun oss cp $(BUILDDIR)/ali-gardener_dev-amd64-$(VERSION)-local/rootfs.qcow2  oss://gardenlinux-development/gardenlinux/$(ALI_DEV_IMAGE_NAME).qcow2


AWS_IMAGE_NAME=$(IMAGE_BASENAME)-aws-$(VERSION)
aws: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,aws $(BUILDDIR)/aws $(VERSION)

aws-upload:
	./bin/make-ec2-ami --bucket gardenlinux-testing --region eu-north-1 --image-name=$(AWS_IMAGE_NAME) $(BUILDDIR)/aws-gardener-amd64-$(VERSION)-local/rootfs.raw --permission-public "$(PUBLIC)" --distribute "$(AWS_DISTRIBUTE)"

AWS_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-dev-aws-$(VERSION)
aws-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,aws,_dev $(BUILDDIR)/aws-dev ${VERSION}

aws-dev-upload:
	./bin/make-ec2-ami --bucket ami-debian-image-test --region eu-north-1 --image-name=$(AWS_DEV_IMAGE_NAME) $(BUILDDIR)/aws-gardener_dev-amd64-$(VERSION)-local/rootfs.raw --permission-public "$(PUBLIC)" --distribute "$(AWS_DISTRIBUTE)"

GCP_IMAGE_NAME=$(IMAGE_BASENAME)-gcp-$(VERSION)
gcp: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,gcp $(BUILDDIR)/gcp $(VERSION)

gcp-upload:
	./bin/make-gcp-ami --bucket garden-linux-test --image-name $(GCP_IMAGE_NAME) --raw-image-path $(BUILDDIR)/gcp-gardener-amd64-$(VERSION)-local/rootfs-gcpimage.tar.gz --permission-public "$(PUBLIC)"

GCP_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-dev-gcp-$(VERSION)
gcp-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,gcp,_dev $(BUILDDIR)/gcp-dev $(VERSION)

gcp-dev-upload:
	./bin/make-gcp-ami --bucket garden-linux-test --image-name $(GCP_DEV_IMAGE_NAME) --raw-image-path $(BUILDDIR)/gcp-gardener_dev-amd64-$(VERSION)-local/rootfs-gcpimage.tar.gz --permission-public "$(PUBLIC)"

AZURE_IMAGE_NAME=$(IMAGE_BASENAME)-az-$(VERSION)
azure: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,azure $(BUILDDIR)/azure $(VERSION)

azure-upload:
	./bin/make-azure-ami --resource-group garden-linux --storage-account-name gardenlinux --image-path=$(BUILDDIR)/azure-gardener-amd64-$(VERSION)-local/rootfs.vhd --image-name=$(AZURE_IMAGE_NAME)

AZURE_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-dev-az-$(VERSION)
azure-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,azure,_dev $(BUILDDIR)/azure-dev $(VERSION)

azure-dev-upload:
	./bin/make-azure-ami --resource-group garden-linux --storage-account-name gardenlinuxdev --image-path=$(BUILDDIR)/azure-gardener_dev-amd64-$(VERSION)-local/rootfs.vhd --image-name=$(AZURE_DEV_IMAGE_NAME)


OPENSTACK_IMAGE_NAME=$(IMAGE_BASENAME)-openstack-$(VERSION)
openstack: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,openstack $(BUILDDIR)/openstack $(VERSION)

openstack-upload:
	./bin/upload-openstack $(BUILDDIR)/openstack-gardener-amd64-$(VERSION)-local/rootfs.vmdk $(OPENSTACK_IMAGE_NAME)

OPENSTACK_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-openstack-dev-$(VERSION)
openstack-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,openstack,_dev $(BUILDDIR)/openstack-dev $(VERSION)

openstack-dev-upload:
	./bin/upload-openstack $(BUILDDIR)/openstack-dev/$(SNAPSHOT_DATE)/rootfs.vmdk $(OPENSTACK_DEV_IMAGE_NAME)

openstack-qcow2: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --features server,cloud,gardener,openstack-qcow2 $(BUILDDIR)/openstack-qcow2 $(VERSION)

VMWARE_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-vmware-dev-$(VERSION)
vmware-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,vmware,_dev $(BUILDDIR)/vmware-dev $(VERSION)

VMWARE_VMOPERATOR_DEV_IMAGE_NAME=$(IMAGE_BASENAME)-vmware-vmoperator-dev-$(VERSION)
vmware-vmoperator-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,vmware-vmoperator,_dev $(BUILDDIR)/vmware-vmoperator-dev $(VERSION)

vmware: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,gardener,vmware $(BUILDDIR)/vmware $(VERSION)

cloud: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud $(BUILDDIR)/cloud $(VERSION)

kvm: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,kvm $(BUILDDIR)/kvm $(VERSION)

kvm-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,kvm,_dev $(BUILDDIR)/kvm-dev $(VERSION)

pxe: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,_pxe $(BUILDDIR)/pxe $(VERSION)

pxe-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,_dev,_pxe $(BUILDDIR)/pxe-dev $(VERSION)

pxev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,vhost,_pxe $(BUILDDIR)/pxev $(VERSION)

pxev-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud,vhost,_dev,_pxe $(BUILDDIR)/pxev-dev $(VERSION)

anvil: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,cloud-anvil,kvm,_dev $(BUILDDIR)/anvil $(VERSION)

onmetal: metal
metal: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,metal $(BUILDDIR)/metal $(VERSION)

metal-dev: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,metal,_dev $(BUILDDIR)/metal-dev $(VERSION)

metalk: container-build cert/sign.pub
	./build.sh  --arch=$(ARCH) --no-build --features server,metal,chost,khost,_pxe $(BUILDDIR)/metalk $(SNAPSHOT_DATE)

clean:
	@echo "emptying $(BUILDDIR)"
	@rm -rf $(BUILDDIR)/*
	@echo "deleting all containers running gardenlinux/build-image"
	@-docker container rm $$(docker container ls -a | awk '{ print $$1,$$2 }' | grep gardenlinux/build-image: | awk '{ print $$1 }') 2> /dev/null || true
	@echo "deleting all containers running gardenlinux/integration-test"
	@-docker container rm $$(docker container ls -a | awk '{ print $$1,$$2 }' | grep gardenlinux/integration-test: | awk '{ print $$1 }') 2> /dev/null || true

distclean: clean
	make --directory=docker clean

# Composing a Garden Linux

Garden Linux is a Debian derivate designed to run container workload
for most Cloud Providers and bare Metal. Garden Linux is a small and
auditable specialized linux distribution, tailored for one target platform.

To have both, a wide range of supported platforms and a minimal
Garden Linux image, Garden Linux Repository comes with a configurable
compositional build pipeline.

This build pipeline is described in Chapter [Build Pipeline](#build-pipeline).
But first, we will clarify terminology in the following sub chapters before.



## Flavor
By selecting a **flavor** of garden linux, you get support for
the specified platform (the flavor). This will install additional packages required by the
platform. Depending on the requirements of the platform, additional
configurational steps may be performed during the build pipeline steps.


**Flavors** are located in the ```features``` folder. The following flavors are available
 - *ali* - Alibaba Cloud
 - *aws* - Amazon Web Services
 - *gcp* - Google Cloud Platform
 - *azure* - Microsoft Azure
 - *openstack* - OpenStack (OpenStack API with ESXi hypervisor)
 - *vmware* - VMware
 - *kvm* - KVM
 - *metal* - Bare Metal


## Features

While you should only have one falvor selected, you can compose your Garden
Linux with multiple **Features** and Modifiers.
A **Feature** installs additional packages, and may prepare your image with
additional configurational steps.

**Feature** code is located in subfolders of the ```features/``` folder. Available Features are
listed in the table below.
|   Feature				| Brief Description 	|
|---					|---			|
| [base](../features/base/) 		| Included in every Garden Linux Image |
| [chost](../features/chost/) 		| Basis for khsot and gardener 			|
| [khost](../features/khost/)		| Uses vanilla kubernetes tools for hosting container workload |
| [gardener](../features/gardener/)	| Gardener.cloud requirements for hosting container worload  |
| [cis](../features/cis/)		| Debian hardening tests. For details please check https://github.com/ovh/debian-cis |
| [cloud](../features/cloud/)		| Base for all Cloud platforms. Automatically selected when you choose a platform. Installs Cloud Kernel. 			|
| [fedramp](../features/fedramp/)	| Tests required for U.S. Governement Cloud Service offerings. Please check https://www.fedramp.gov for context. |
| [vhost](../features/vhost)		|  			|
| [server](../features/server)		| Includes common packages and configurations used by metal and cloud |

To create a new feature, check out the template feature [example](../features/example/).

## Modifiers

They are general changes to the system.
**Modifiers** are located in subfolders of the ```features/``` folder,
and can be identified by a leading underscore before their name.

### Available Modifiers
|   Modifier	| Brief Description |
|---		|---	|
| [_build](../features/_build/) 	| a 	|
| [_dev](../features/_dev) 		|  	|
| [_ignite](../features/_ignite)	|  	|
| [_nopkg](../features/_nopkg)		|  	|
| [_prod](../features/_prod)		|  	|
| [_pxe](../features/_pxe)		|  	|
| [_readonly](../features/_readonly)	|  	|
| [_slim](../features/slim)		|  	|


## Build Pipeline

The build pipeline consists of multiple steps, where each step is configured by
files within this repository. How each step is configured is explained in
the following respective sub chapters.


### init (aka gardeninit)

- TODO: describe in detail what happens in init

### exec.pre (not implemented)

- TODO: describe in detail what is planned

### copy

- TODO: describe in detail what happens

### exec.config

- TODO: describe in detail what happens

### delete

- TODO: describe in detail what happens

### exec.post (not implemented)

- TODO: describe in detail what happens


- TODO: describe pipeline
  - how gardenlinux is composed
  - show all steps that exist
  - explain each step briefly

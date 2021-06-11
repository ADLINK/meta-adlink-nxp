# Copyright (C) 2015 Freescale Semiconductor
# Copyright 2017-2018 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Freescale Image to validate i.MX machines. \
This image contains everything used to test i.MX machines including GUI, \
demos and lots of applications. This creates a very large image, not \
suitable for production."
LICENSE = "MIT"

IMAGE_FSTYPES_append = " wic wic.xz"
IMAGE_FSTYPES_remove = "tar tar.bz2 ext4"

# We do not want to install much
PACKAGE_INSTALL = "packagegroup-core-boot \
  packagegroup-base-extended \
  packagegroup-adlink-wifi \
  packagegroup-adlink-bluetooth \
  fcc-mfgbridge \
  run-postinsts \
  dpkg \
  apt \
  packagegroup-core-ssh-openssh \
"
# packagegroup-core-boot
# packagegroup-base-extended
# packagegroup-adlink
# jailhouse
# packagegroup-fsl-optee-imx
# run-postinsts
# dpkg
# apt
# packagegroup-core-ssh-openssh

IMAGE_LINGUAS = ""

LICENSE = "MIT"

inherit core-image

# Following is for appearance as we are only building /boot vfat partition
IMAGE_ROOTFS_SIZE = "0"
IMAGE_ROOTFS_EXTRA_SPACE = "0"
IMAGE_OVERHEAD_FACTOR = "1.0"


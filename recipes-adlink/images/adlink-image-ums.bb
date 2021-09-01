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
WKS_FILE = "adlink-imx8-imxboot-fit.wks.in"
WKS_FILE_DEPENDS_mx8 += "imx-boot u-boot-script"
IMAGE_BOOT_FILES = "boot.scr.uimg;boot.scr"
IMAGE_BOOT_FILES_append_arm = " u-boot-${MACHINE}.${UBOOT_SUFFIX};u-boot.img boot.scr.uimg;boot.scr"

# We do not want to install anything, only need the wic packaging"
IMAGE_INSTALL_remove = "packagegroup-core-boot packagegroup-base-extended"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

IMAGE_LINGUAS = ""

LICENSE = "MIT"

inherit core-image

# Following is for appearance as we are only building /boot vfat partition
IMAGE_ROOTFS_SIZE = "0"
IMAGE_ROOTFS_EXTRA_SPACE = "0"
IMAGE_OVERHEAD_FACTOR = "1.0"

RDEPENDS_${PN} += "bash"
DEPENDS += "e2fsprogs-native dosfstools-native mtools-native parted-native"
do_image_wic[depends] = "u-boot-script:do_install"

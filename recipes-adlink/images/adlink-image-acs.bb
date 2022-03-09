# Copyright (C) 2021 ADLINK Technology Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "ADLINK Image for ArmSystemReady IR validation on i.MX machines. \
This image contains boot-able u-boot (imx-boot) with u-boot dtb file in a EFI System Partition. \
This creates a very small, just enought to load grub efi binary using u-boot's distro-boot."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

IMAGE_FSTYPES_append = " wic.xz"
IMAGE_FSTYPES_remove = "tar tar.bz2 wic.bz2 ext4"

WKS_FILE = "adlink-imx8-imxboot-acs.wks.in"
WKS_FILE_DEPENDS_mx8 += "imx-boot"

# u-boot-script
IMAGE_BOOT_FILES := "${DEPLOY_DIR_IMAGE}/imx-boot-tools/${UBOOT_DTB_NAME};${UBOOT_DTB_NAME}"

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
DEPENDS += "e2fsprogs-native dosfstools-native mtools-native parted-native gptfdisk-native"
do_image_wic[depends] = "imx-boot:do_install"

WIC_SRC_ROOTFS = ""

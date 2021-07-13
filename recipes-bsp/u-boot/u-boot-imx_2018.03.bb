# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2017-2018 NXP

DESCRIPTION = "i.MX U-Boot suppporting i.MX reference boards."
require recipes-bsp/u-boot/u-boot.inc
inherit pythonnative

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PROVIDES += "u-boot"
DEPENDS_append = " python dtc-native"


LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

UBOOT_SRC ?= "git://source.codeaurora.org/external/imx/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2018.03_4.14.78_1.0.0_ga"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH} \
"
SRCREV = "7ade5b407fe6164c0d07f32f72e487ae5f6f3964"

S = "${WORKDIR}/git"

inherit fsl-u-boot-localversion

LOCALVERSION ?= "-4.14.78_1.0.0"

BOOT_TOOLS = "imx-boot-tools"

do_deploy_append_mx8m () {
    # Deploy the mkimage, u-boot-nodtb.bin and fsl-imx8mq-XX.dtb for mkimage to generate boot binary
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    install -d ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/arch/arm/dts/${UBOOT_DTB_NAME}  ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/u-boot-nodtb.bin  ${DEPLOYDIR}/${BOOT_TOOLS}/u-boot-nodtb.bin-${MACHINE}-${UBOOT_CONFIG}
                fi
            done
            unset  j
        done
        unset  i
    fi

}

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

UBOOT_NAME_mx6 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx7 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"
UBOOT_NAME_mx8 = "u-boot-${MACHINE}.bin-${UBOOT_CONFIG}"

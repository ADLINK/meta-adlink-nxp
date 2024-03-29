# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require recipes-connectivity/nxp-bt-sdk/adlink-bt-sdk_git.inc

SUMMARY = "bt driver for NXP-W9887 WIFI/BT module"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI:append:lec-imx8mp = " \
  file://blacklist.conf \
  file://bt8xxx.conf \
  file://0001-fix-break-due-to-change-in-timestructs-procops.patch \
"
SRC_URI:append:lec-imx8mm = " \
  file://0001-Added-kernel-version-5.13.19-support.patch \
"


inherit module

DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
  KERNELDIR=${STAGING_KERNEL_DIR} \
"
# CONFIG_DEBUG=1
# CONFIG_SDIO_SUSPEND_RESUME=y     -> SDIO suspend/resume

S_lec-imx8mp = "${WORKDIR}/git/mbtex_8997"

KERNEL_MODULE_AUTOLOAD += " bt8xxx"


MODPROBE_CONFFILE = "${@bb.utils.contains('DISTRO_FEATURES', 'fcc', 'blacklist.conf', 'bt8xxx.conf', d)}"

do_install:append () {
  install -d ${D}${sysconfdir}/modprobe.d
#install -m 644 ${WORKDIR}/${MODPROBE_CONFFILE} ${D}${sysconfdir}/modprobe.d/
}

FILES_${PN} += "${sysconfdir}/modprobe.d"


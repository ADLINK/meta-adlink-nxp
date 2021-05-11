# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-connectivity/nxp-bt-sdk/adlink-bt-sdk_git.inc

SUMMARY = "bt driver for NXP-W9887 WIFI/BT module"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit module

DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
  KERNELDIR=${STAGING_KERNEL_DIR} \
"
# CONFIG_DEBUG=1
# CONFIG_SDIO_SUSPEND_RESUME=y     -> SDIO suspend/resume

S = "${WORKDIR}/git/mbtex_8997"

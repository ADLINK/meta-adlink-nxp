# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-connectivity/nxp-bt-sdk/adlink-bt-sdk_git.inc

SUMMARY = "bt driver for NXP-W9887 WIFI/BT module"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI_append = " \
  file://blacklist.conf \
"

inherit module

DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
  KERNELDIR=${STAGING_KERNEL_DIR} \
"
# CONFIG_DEBUG=1
# CONFIG_SDIO_SUSPEND_RESUME=y     -> SDIO suspend/resume

S = "${WORKDIR}/git/mbtex_8997"

MODPROBE_CONFFILE = "${@bb.utils.contains('DISTRO_FEATURES', 'fcc', 'blacklist.conf', '', d)}"

do_install_append () {
  install -d ${D}${sysconfdir}/modprobe.d
  if [ -f ${WORKDIR}/${MODPROBE_CONFFILE} ]; then
    install -m 644 ${WORKDIR}/${MODPROBE_CONFFILE} ${D}${sysconfdir}/modprobe.d/
  fi
}

FILES_${PN} += "${sysconfdir}/modprobe.d"


# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "gpio-switch driver to control RS232/RS244/RS485 operation mode"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = " \
  file://gpioswitch.tar.gz \
"

inherit module

DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
  KERNELDIR=${STAGING_KERNEL_DIR} \
"

# CONFIG_DEBUG=1
S = "${WORKDIR}/src"

KERNEL_MODULE_AUTOLOAD += " gpio_switch"


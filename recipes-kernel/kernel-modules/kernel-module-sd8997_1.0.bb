# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-connectivity/nxp-wlan-sdk/adlink-wlan-sdk_git.inc

SUMMARY = "moal driver for NXP-W9887 WIFI/BT module via sdio"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI_append = " file://sd8xxx.conf"

inherit module

DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
  KERNELDIR=${STAGING_KERNEL_DIR} \
"
# CONFIG_DEBUG=1
# CONFIG_PROC_DEBUG=y              -> Proc debug file
# CONFIG_STA_SUPPORT=y             -> Enable STA mode support
# CONFIG_UAP_SUPPORT=y             -> Enable uAP mode support
# CONFIG_WIFI_DIRECT_SUPPORT=y     -> Enable WIFIDIRECT support
# CONFIG_WIFI_DISPLAY_SUPPORT=y    -> Enable WIFIDISPLAY support
# CONFIG_REASSOCIATION=y           -> Re-association in driver
# CONFIG_MFG_CMD_SUPPORT=y         -> Manufacturing firmware support
# CONFIG_OPENWRT_SUPPORT=n         -> OpenWrt support
# CONFIG_BIG_ENDIAN=n              -> Big-endian platform
# CONFIG_EMBEDDED_SUPP_AUTH=y      -> if CONFIG_DRV_EMBEDDED_SUPPLICANT=y or CONFIG_DRV_EMBEDDED_AUTHENTICATOR=y
# CONFIG_SDIO_OOB_IRQ=n            ->
# CONFIG_SDIO_MULTI_PORT_TX_AGGR=y -> Enable SDIO multi-port Tx aggregation
# CONFIG_SDIO_MULTI_PORT_RX_AGGR=y -> Enable SDIO multi-port Rx aggregation
# CONFIG_SDIO_SUSPEND_RESUME=y     -> SDIO suspend/resume
# CONFIG_DFS_TESTING_SUPPORT=y     -> DFS testing support
# CONFIG_MULTI_CHAN_SUPPORT=y      -> Multi-channel support
# CONFIG_ANDROID_KERNEL=n          -> Android Kernel
# CONFIG_USERSPACE_32BIT_OVER_KERNEL_64BIT=n -> 32bit app over 64bit kernel support

S = "${WORKDIR}/git/mwifiex_8997"

do_install_append () {
   install -d ${D}${sysconfdir}/modprobe.d
   install -m 644 ${WORKDIR}/sd8xxx.conf ${D}${sysconfdir}/modprobe.d
}

FILES_${PN} += "${sysconfdir}/modprobe.d"


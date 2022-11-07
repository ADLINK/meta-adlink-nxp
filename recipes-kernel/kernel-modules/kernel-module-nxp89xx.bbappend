# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx8mm = " \
  file://blacklist.conf \
"

do_install_append_lec-imx8mm () {
   install -d ${D}${sysconfdir}/modprobe.d
   install -m 644 ${WORKDIR}/blacklist.conf ${D}${sysconfdir}/modprobe.d/

}

FILES_${PN} += "${sysconfdir}/modprobe.d"

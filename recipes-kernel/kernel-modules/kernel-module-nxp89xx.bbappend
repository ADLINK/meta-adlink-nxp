# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
  file://mlan.conf \
  file://moal.conf \
"

do_install_append_lec-imx8mp () {
   install -d ${D}${sysconfdir}/modprobe.d
   # if building wifi/bt, then copy mlan.conf moal.conf
   install -m 644 ${WORKDIR}/mlan.conf ${D}${sysconfdir}/modprobe.d/
   install -m 644 ${WORKDIR}/moal.conf ${D}${sysconfdir}/modprobe.d/
}

FILES_${PN} += "${sysconfdir}/modprobe.d"

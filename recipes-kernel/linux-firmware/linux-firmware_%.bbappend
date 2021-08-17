# Copyright 2020-2021 ADLINK
#
# Support additional firmware for nxp 88w8997 sdio wifi/bt module
#

SRCREV_adlink-sd8997 ?= "8dd5e83af101e3c8de05e4885fbc273f2fdd0968"
ADLINK_FIRMWARE_SRC ?= "git://github.com/ADLINK/nxp-w8997-fwimage.git"
ADLINK_SRCBRANCH ?= "main"
SRC_URI_append_wifibt = "\
    ${ADLINK_FIRMWARE_SRC};branch=${ADLINK_SRCBRANCH};protocol=https;user=${PA_USER}:${PA_TOKEN};name=adlink-sd8997;destsuffix=adlink-sd8997 \
"

SD8997_FWDIR := "${@bb.utils.contains('DISTRO_FEATURES', 'fcc', 'FwImageFcc', 'FwImage', d)}"

do_install_append_wifibt () {
    # Install NXP Connectivity sd8997 firmware
    install -d ${D}/lib/firmware/nxp
    for binfile in ${WORKDIR}/adlink-sd8997/${SD8997_FWDIR}/*.bin; do
      install -m 0644 ${binfile} ${D}/lib/firmware/nxp
    done
}

PACKAGES =+ " ${PN}-sd8997"
LICENSE_${PN}-sd8997 = "Firmware-Marvell"

FILES_${PN}-sd8997_append_wifibt = " \
    /lib/firmware/nxp/ \
"

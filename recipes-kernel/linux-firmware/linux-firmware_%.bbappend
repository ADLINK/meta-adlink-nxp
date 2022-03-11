# Copyright 2020-2021 ADLINK
#
# Support additional firmware for nxp 88w8997 sdio wifi/bt module
#

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# SDIO-UART W8997 Firmware version 16.92.10.p219.5 (from meta-imx)

# FCC W8997 Firmware version 16.80.205.p207

SRCREV_adlink-sd8997 = "d1659d1d1af646533e0e79feaf55a6aed6e0fad8"
ADLINK_BRANCH = "p207"
ADLINK_FIRMWARE_SRC = "git://github.com/ADLINK/nxp-w8997-fwimage.git;protocol=https;branch=${ADLINK_BRANCH};user=${PA_USER}:${PA_TOKEN}"
SRC_URI += "\
    ${ADLINK_FIRMWARE_SRC};name=adlink-sd8997;destsuffix=adlink-sd8997 \
    file://fcc-wifi_mod_para.conf \
"

SD8997_FWDIR := "${@bb.utils.contains('DISTRO_FEATURES', 'fcc', 'FwImageFcc', 'FwImage', d)}"

do_install_append () {
    if [ "${SD8997_FWDIR}" = "FwImageFcc" ]; then
        # Install NXP Connectivity sd8997 fcc verification firmware
        install -d ${D}/lib/firmware/nxp
        for binfile in ${WORKDIR}/adlink-sd8997/${SD8997_FWDIR}/*.bin; do
            install -m 0644 ${binfile} ${D}/lib/firmware/nxp
        done
        install -m 0644 ${WORKDIR}/fcc-wifi_mod_para.conf ${D}${nonarch_base_libdir}/firmware/nxp/
    fi
}

LICENSE_${PN}-nxp89xx = "Firmware-Marvell"

FILES_${PN}-nxp89xx_append = " \
    ${nonarch_base_libdir}/firmware/nxp/ \
"

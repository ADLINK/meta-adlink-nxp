# Copyright 2020-2021 ADLINK
#
# Support additional firmware for nxp 88w8997 sdio wifi/bt module
#

SRCREV_adlink-sd8997 ?= "efd4efaeab8890e74e42c94f35d6eac9ab9df3b2"
ADLINK_FIRMWARE_SRC ?= "git://github.com/ADLINK/nxp-w8997-fwimage.git"
ADLINK_SRCBRANCH ?= "main"
SRC_URI_append_wifibt = "\
    ${ADLINK_FIRMWARE_SRC};branch=${ADLINK_SRCBRANCH};protocol=https;user=${PA_USER}:${PA_TOKEN};name=adlink-sd8997;destsuffix=adlink-sd8997 \
"

do_install_append_wifibt () {
    # Install NXP Connectivity sd8997 firmware
    install -m 0644 ${WORKDIR}/adlink-sd8997/FwImage/sdsd8997_combo_v4.bin ${D}/lib/firmware/nxp
    install -m 0644 ${WORKDIR}/adlink-sd8997/FwImage/sd8997_wlan_v4.bin ${D}/lib/firmware/nxp
    install -m 0644 ${WORKDIR}/adlink-sd8997/FwImage/sd8997_bt_v4.bin ${D}/lib/firmware/nxp
    install -m 0644 ${WORKDIR}/adlink-sd8997/FwImage/r3p_R0_X8.bin ${D}/lib/firmware/nxp
}

PACKAGES =+ " ${PN}-sd8997"
LICENSE_${PN}-sd8997 = "Firmware-Marvell"

FILES_${PN}-sd8997_append_wifibt = " \
    /lib/firmware/nxp/sdsd8997_combo_v4.bin \
    /lib/firmware/nxp/sd8997_wlan_v4.bin \
    /lib/firmware/nxp/sd8997_bt_v4.bin \
    /lib/firmware/nxp/r3p_R0_X8.bin \
"

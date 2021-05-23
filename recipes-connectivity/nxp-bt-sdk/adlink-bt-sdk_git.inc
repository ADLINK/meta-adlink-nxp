SUMMARY = "NXP BT SDK for SDIO 88w8997 and 88w8987"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://mwifiex_8997/gpl-2.0.txt;md5=ab04ac0f249af12befccb94447c08b77;"

ADLINK_SRC ?= "git://github.com/po-cheng-adlink/mwifiex-adlink.git"

# Kernel 5.4
SRCBRANCH = "adlink-imx_5.4.70.2.3.0"
SRC_URI = "${ADLINK_SRC};branch=${SRCBRANCH};protocol=https"
SRCREV = "61561d1070350058a0a809624c3c283d7bc7f474"

S = "${WORKDIR}/git"

RRECOMMENDS_${PN} = "wireless-tools"

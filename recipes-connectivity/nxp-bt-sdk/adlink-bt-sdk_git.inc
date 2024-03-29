SUMMARY = "NXP BT SDK for SDIO 88w8997 and 88w8987"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://mwifiex_8997/gpl-2.0.txt;md5=ab04ac0f249af12befccb94447c08b77;"



ADLINK_SRC = "${@bb.utils.contains('MACHINE', 'lec-imx8mp', 'git://github.com/ADLINK/mwifiex-adlink.git', 'git://github.com/AdlinkCCoE/mbtc_src.git', d)}"
SRCBRANCH = "${@bb.utils.contains('MACHINE', 'lec-imx8mp', 'adlink-imx_5.4.70.2.3.0', 'main', d)}"
SRCREV = "${@bb.utils.contains('MACHINE', 'lec-imx8mp', '61561d1070350058a0a809624c3c283d7bc7f474', '4f9a85b08a6b8114ff59967dc15c7bcc6ebd931e', d)}"


SRC_URI = "${ADLINK_SRC};branch=${SRCBRANCH};protocol=https;"


S = "${WORKDIR}/git"

RRECOMMENDS_${PN} = "wireless-tools"

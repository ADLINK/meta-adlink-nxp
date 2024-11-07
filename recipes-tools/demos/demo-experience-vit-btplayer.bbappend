FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:osm-imx93 = " file://0001-changed-BUILD_ARCH-CortexA55.patch "

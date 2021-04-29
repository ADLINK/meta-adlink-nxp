FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LIC_FILES_CHKSUM = "file://COPYING;md5=91e7de50a8d3cf01057f318d72460acd"
SRCREV = "e15ce6fbc76148ba8835adc92196b0d0a3f245e7"

SRC_URI += "\
	file://0001-LEC-iMX8MP-Add-board-file-changes-for-imx8mp.patch \
	file://0002-Added-Test-applications-support.patch \
"

do_install_append() {
	install -d ${D}/usr/share/mraa
	cp -r ${B}/examples/ ${D}/usr/share/mraa
}

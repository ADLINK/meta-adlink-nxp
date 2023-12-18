SUMMARY = "Bash Script to Fuse MAC address on i.MX 6,7,8 series"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
	file://fuse-mac.sh \
"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${sbindir}
	install -m 755 ${S}/fuse-mac.sh ${D}${sbindir}/fuse-mac.sh
}

FILES:${PN} += "${sbindir}/"

RDEPENDS:${PN}:append = " bash binutils"


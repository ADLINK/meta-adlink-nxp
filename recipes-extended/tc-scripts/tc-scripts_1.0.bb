SUMMARY = "Script to control linux traffic control for testing Time Sensitive Network"
DESCRIPTION = "Ethernet Time Sensitive Network TC control script"
SECTION = "app"
LICENSE = "GPLv3"
LICENSE_FLAGS = "commercial_adlink"

LIC_FILES_CHKSUM = "file://qbv_8mp.sh;md5=146e888b2db8da213e9f37e478bbb4a9"

SRC_URI = " \
    file://qbv_8mp.sh \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# install qbv_8mp.sh script
	install -d ${D}${bindir}
	install -m 0755 ${S}/qbv_8mp.sh ${D}${bindir}/
}

FILES_${PN} += "${bindir}"

RDEPENDS_${PN} += "bash"

LICENSE_FLAGS_WHITELIST += "commercial_adlink"

SUMMARY = "A collection of scripts to help with SystemReady compliance certification"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

SRCSERVER = "git://git.gitlab.arm.com/systemready/systemready-scripts.git"
SRCBRANCH = "3.0.1"
SRCOPTIONS = ";protocol=https"
SRCREV = "b2b2f998bd44c375898f0cb89f346f7ab464dd56"
SRC_URI = "${SRCSERVER};branch=${SRCBRANCH}${SRCOPTIONS}"

S = "${WORKDIR}/git"

do_compile[noexec] = "1"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/capsule-tool.py ${D}${bindir}/capsule-tool.py
	install -m 0755 ${S}/guid.py ${D}${bindir}/guid.py
	install -m 0755 ${S}/guid-tool.py ${D}${bindir}/guid-tool.py
	install -m 0755 ${S}/guid-tool.yaml ${D}${bindir}/guid-tool.yaml
}

FILES:${PN} += "${bindir}/"

RDEPENDS:${PN}:append = " python3 python3-construct"

BBCLASSEXTEND = "native nativesdk"


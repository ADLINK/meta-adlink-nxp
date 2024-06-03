FILESEXTRAPATHS:prepend := "${THISDIR}/r8168:"

SUMMARY = "r8168 ethernet driver"
DESCRIPTION = "r8168 ethernet driver "
SECTION = "Driver"

LICENSE = "CLOSED"
//LIC_FILES_CHKSUM = "file://LICENSE;md5=668dadc533e6a21b2b63819f4c8dcee8"

inherit module
SRCBRANCH = "main"
SRCREV = "f23ea15728bdfd81651f071cabadb69f3a8dc118"
SRC_URI = "git://github.com/AdlinkCCoE/r8168.git;branch=${SRCBRANCH};protocol=http \
           "

SRC_URI:append ="file://Makefile \
		 file://0001-r8168_n-downgrade-kernel-apis.patch \
		 file://blacklist.conf "

S = "${WORKDIR}/git"


do_compile:prepend() {
	rm -r ${WORKDIR}/git/Makefile
	cp ${WORKDIR}/Makefile ${WORKDIR}/git/Makefile
}

MODPROBE_CONFFILE = "blacklist.conf"

do_install:append () {
  install -d ${D}${sysconfdir}/modprobe.d
  install -m 644 ${WORKDIR}/${MODPROBE_CONFFILE} ${D}${sysconfdir}/modprobe.d/
}

FILES:${PN} += "${sysconfdir}/modprobe.d"

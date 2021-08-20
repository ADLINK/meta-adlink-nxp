SUMMARY = "Script to enable ethernet level shift output enable"
DESCRIPTION = "Ethernet LevelShit Output Enable script"
SECTION = "app"
LICENSE = "GPLv3"
LICENSE_FLAGS = "commercial_adlink"

LIC_FILES_CHKSUM = "file://eth-lsoe.sh;md5=b5bac77068148f614a5f919b791b3c8e"

SRC_URI = " \
    file://eth-lsoe.sh \
    file://eth-lsoe.service \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# add the service to systemd
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 0644 ${S}/eth-lsoe.service ${D}${systemd_unitdir}/system/
	# enable the service
	ln -sf ${systemd_unitdir}/system/eth-lsoe.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/eth-lsoe.service

	# install eth-lsoe script
	install -d ${D}${bindir}
	install -m 0755 ${S}/eth-lsoe.sh ${D}${bindir}/
}

FILES_${PN} += "${bindir}"
FILES_${PN} += "${systemd_unitdir}/system/"
FILES_${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/"

RDEPENDS_${PN} += "bash i2c-tools"

LICENSE_FLAGS_WHITELIST += "commercial_adlink"

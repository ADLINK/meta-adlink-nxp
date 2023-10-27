SUMMARY = "UART-Mode script to set uart to RS232 mode"
DESCRIPTION = "UART-Mode script"
SECTION = "app"
LICENSE = "Closed"
LICENSE_FLAGS = "commercial_adlink"

LIC_FILES_CHKSUM = "file://README.md;md5=d5c25e2f902b7b1c7ac0856976f99668"

SRC_URI = " \
    file://uart-mode.sh \
    file://uart-mode.service \
    file://README.md \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# add the service to systemd
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 0644 ${S}/uart-mode.service ${D}${systemd_unitdir}/system/
	# enable the service
	ln -sf ${systemd_unitdir}/system/uart-mode.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/uart-mode.service

	# install UART-Mode script
	install -d ${D}${bindir}
	install -m 0755 ${S}/uart-mode.sh ${D}${bindir}/
}

FILES:${PN} += "${bindir}"
FILES:${PN} += "${systemd_unitdir}/system/"
FILES:${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/"

RDEPENDS_EXTRA = "${@bb.utils.contains('DISTRO', 'imx-desktop-xwayland', '', 'libgpiod-tools', d)}"

RDEPENDS:${PN} += "bash ${RDEPENDS_EXTRA}"

LICENSE_FLAGS_ACCEPTED += "commercial_adlink"

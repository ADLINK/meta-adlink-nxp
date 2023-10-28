SUMMARY = "hciattach Bluetotoh device to uart"
DESCRIPTION = "hciattach script"
SECTION = "app"
LICENSE = "Closed"
LICENSE_FLAGS = "commercial_adlink"

LIC_FILES_CHKSUM = "file://bt-hciattach.service;md5=1221c215beafbe2f50f642fbdb9d2e23"

SRC_URI = " \
    file://bt-hciattach.service \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# add the service to systemd
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 0644 ${S}/bt-hciattach.service ${D}${systemd_unitdir}/system/
	# enable the service
	ln -sf ${systemd_unitdir}/system/bt-hciattach.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/bt-hciattach.service
}

FILES:${PN} += "${systemd_unitdir}/system/"
FILES:${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/"

LICENSE_FLAGS_ACCEPTED += "commercial_adlink"

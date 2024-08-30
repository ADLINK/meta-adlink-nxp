SUMMARY = "hciattach Bluetotoh device to uart"
DESCRIPTION = "hciattach script"
SECTION = "app"
LICENSE = "Proprietary"

LIC_FILES_CHKSUM = "file://bt-hciattach.sh;md5=3098eb23dc39a2aeb3d6a8cb67c29e85"

SRC_URI = " \
    file://bt-hciattach.service \
    file://bt-hciattach.sh \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# add the setup bash script to /usr/sbin
	install -d ${D}${sbindir}/
	install -m 0755 ${S}/bt-hciattach.sh ${D}${sbindir}/
	# add the service to systemd
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 0644 ${S}/bt-hciattach.service ${D}${systemd_unitdir}/system/
	# enable the service
	ln -sf ${systemd_unitdir}/system/bt-hciattach.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/bt-hciattach.service
}

FILES:${PN} += "${sbindir}/ ${systemd_unitdir}/system/ ${sysconfdir}/systemd/system/multi-user.target.wants/"

RDEPENDS:${PN} += "bash"


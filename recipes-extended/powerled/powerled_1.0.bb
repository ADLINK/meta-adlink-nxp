SUMMARY = "Power LED script to turn on BMC_GREEN_LED once OS is in RunTime state"
DESCRIPTION = "Power LED script"
SECTION = "app"
LICENSE = "GPLv3"
LICENSE_FLAGS = "commercial_adlink"

LIC_FILES_CHKSUM = "file://powerled.sh;md5=e5b4bed06d2284416d5ba3532e2ec2a3"

SRC_URI = " \
    file://powerled.sh \
    file://powerled.service \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# add the service to systemd
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 0644 ${S}/powerled.service ${D}${systemd_unitdir}/system/
	# enable the service
	ln -sf ${systemd_unitdir}/system/powerled.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/powerled.service

	# install Power LED script
	install -d ${D}${bindir}
	install -m 0755 ${S}/powerled.sh ${D}${bindir}/
}

FILES_${PN} += "${bindir}"
FILES_${PN} += "${systemd_unitdir}/system/"
FILES_${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/"

RDEPENDS_${PN} += "bash i2c-tools"

LICENSE_FLAGS_WHITELIST += "commercial_adlink"

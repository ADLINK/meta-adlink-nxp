SUMMARY = "adlink-imx8mp startup service"
DESCRIPTION = "This is to implement a service to run necessary commands on boot"
LICENSE = "CLOSED"

SRC_URI = "\
    file://adlink-imx8mp-startup \
    file://adlink-imx8mp-startup.service \
"

inherit pkgconfig systemd 

SYSTEMD_PACKAGES += "${PN}"
SYSTEMD_SERVICE_${PN} = "adlink-imx8mp-startup.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

INITSCRIPT_NAME = "adlink-imx8mp-startup"
INITSCRIPT_PARAMS = "start 99 2 3 4 5 . stop 19 0 1 6 ."

USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "root"

do_install() {
	install -d "${D}${sysconfdir}/init.d"
	install -m 0755 "${WORKDIR}/adlink-imx8mp-startup" "${D}${sysconfdir}/init.d/adlink-imx8mp-startup"

	if ${@bb.utils.contains("DISTRO_FEATURES", 'systemd', 'true', 'false', d)}; then
		install -d "${D}${sbindir}"
		install -m 0755 "${WORKDIR}/adlink-imx8mp-startup" "${D}${sbindir}/adlink-imx8mp-startup"
		install -d "${D}${systemd_unitdir}/system"
		install -m 0644 "${WORKDIR}/adlink-imx8mp-startup.service" "${D}${systemd_unitdir}/system/adlink-imx8mp-startup.service"
	fi
}

FILES_${PN} += "\
	${systemd_unitdir}/system/adlink-imx8mp-startup.service \
	${sysconfdir}/init.d/adlink-imx8mp-startup \
	${sbindir}/adlink-imx8mp-startup \
"

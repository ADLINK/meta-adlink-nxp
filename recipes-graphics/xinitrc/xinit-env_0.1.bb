SUMMARY = "Include .xinitrc to /home/root"
DESCRIPTION = "Add GFX configuration to Yocto OS to different compositors"
AUTHOR = "Azril Ahmad <mohd.azril.ahmad@intel.com>"
SECTION = "examples"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

SRC_URI = "\
    file://xinitrc \
    file://xinitrc.service \
"

inherit pkgconfig systemd

SYSTEMD_PACKAGES += "${PN}"
SYSTEMD_SERVICE_${PN} = "xinitrc.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

S = "${WORKDIR}"

do_install() {
	install -d 0755 ${D}/home/root
	install -m 0755 ${S}/xinitrc ${D}/home/root/.xinitrc

    if ${@bb.utils.contains("DISTRO_FEATURES", 'systemd', 'true', 'false', d)}; then
       
       install -d "${D}${sbindir}"
       install -m 0755 "${WORKDIR}/xinitrc" "${D}${sbindir}/xinitrc"       

       install -d "${D}${systemd_unitdir}/system"
       install -m 0644 "${S}/xinitrc.service" "${D}${systemd_unitdir}/system/xinitrc.service"
    fi
}

FILES_${PN} += "\
        /home/root/.xinitrc \
        ${systemd_unitdir}/system-preset \
        ${sbindir}/xinitrc \
        ${systemd_unitdir}/system/xinitrc \
"

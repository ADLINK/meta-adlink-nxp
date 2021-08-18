require adlink-fcc-mfgbridge_git.inc

SUMMARY = "Marvell mfgbridge app for FCC wifi/bt"

SRC_URI += "file://fcc-mfgbridge.service"

inherit distro_features_check
REQUIRED_DISTRO_FEATURES = "systemd fcc"

DEPENDS += "bluez5 linux-libc-headers"

DEBUG_FLAGS = ""

RDEPENDS_${PN} += "kernel-module-bt-sd8997 kernel-module-sd8997 bluez5"

do_compile () {
    # Change build folder to mbtex_8997
    cd ${S}/bridge_linux_0.1.0.43/bridge/

    oe_runmake build
}

do_install () {
    # install compiled binary
    install -d ${D}${sbindir}/
    cp -f ${S}/bridge_linux_0.1.0.43/bin_mfgbridge/mfgbridge ${D}${sbindir}/
    install -d ${D}${sysconfdir}/
    cp -f ${S}/bridge_linux_0.1.0.43/bin_mfgbridge/bridge_init.conf ${D}${sysconfdir}/
    # systemd mfgbridge service
    install -d ${D}${systemd_unitdir}/system/
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    install -m 0644 ${WORKDIR}/fcc-mfgbridge.service ${D}${systemd_unitdir}/system
    # enable the service
    ln -sf ${systemd_unitdir}/system/fcc-mfgbridge.service \
            ${D}${sysconfdir}/systemd/system/multi-user.target.wants/fcc-mfgbridge.service
}

FILES_${PN} = "${sbindir} ${sysconfdir} ${systemd_unitdir}/system/fcc-mfgbridge.service ${sysconfdir}/systemd/system/multi-user.target.wants/fcc-mfgbridge.service"

INSANE_SKIP_${PN} = "ldflags"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

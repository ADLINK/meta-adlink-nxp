require adlink-fcc-mfgbridge_git.inc

SUMMARY = "Marvell mfgbridge app for FCC wifi/bt"

DEPENDS += "bluez5 linux-libc-headers"

DEBUG_FLAGS = ""

RDEPENDS_${PN} += "kernel-module-nxp89xx bluez5"

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
}

FILES_${PN} = "${sbindir} ${sysconfdir}"

INSANE_SKIP_${PN} = "ldflags"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

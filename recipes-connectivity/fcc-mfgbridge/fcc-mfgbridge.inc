SUMMARY = "Marvell/NXP Wifi/BT mfgbridge app for FCC equipment setup for SDIO 88w8997 and 88w8987"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"


SRC_URI:append = " file://mfgbridge.service"

DEPENDS += "bluez5 linux-libc-headers"

DEBUG_FLAGS = ""

RDEPENDS_${PN} += "kernel-module-nxp89xx bluez5"

S = "${WORKDIR}"

do_replace () {
	# remove CC allows for cross-compiling for arm
	sed -i 's|CC=.*||g' -i ${S}/src_mfgbridge/bridge/Makefile
}
addtask replace before do_compile after do_patch

do_compile () {
    # Change build folder to mbtex_8997
    cd ${S}/src_mfgbridge/bridge/

    oe_runmake build
}

do_install () {
    # install compiled binary
    install -d ${D}${sbindir}/
    cp -f ${S}/src_mfgbridge/bin_mfgbridge/mfgbridge ${D}${sbindir}/
    install -d ${D}${sysconfdir}/
    cp -f ${S}/src_mfgbridge/bin_mfgbridge/bridge_init.conf ${D}${sysconfdir}/

    # systemd mfgbridge service
    install -d ${D}${systemd_unitdir}/system/
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    install -m 0644 ${WORKDIR}/mfgbridge.service ${D}${systemd_unitdir}/system
    # enable the service, not better way but to force link the service file.
    ln -sf ${systemd_unitdir}/system/mfgbridge.service \
        ${D}${sysconfdir}/systemd/system/multi-user.target.wants/mfgbridge.service
}

FILES_${PN} = "${sbindir} ${sysconfdir} ${systemd_unitdir}/system/mfgbridge.service ${sysconfdir}/systemd/system/multi-user.target.wants/mfgbridge.service"

INSANE_SKIP_${PN} = "ldflags"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

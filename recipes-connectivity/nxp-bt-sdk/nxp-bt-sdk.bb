require adlink-bt-sdk_git.inc

SUMMARY = "NXP Bluetooth SDK"

DEPENDS = "virtual/kernel"

EXTRA_OEMAKE += " \
    KERNELDIR=${STAGING_KERNEL_BUILDDIR} \
"

do_compile () {
    # Change build folder to mbtex_8997
    cd ${S}/mbtex_8997

    export ARCH=arm64
    export CROSS_COMPILE=aarch64-poky-linux-

    oe_runmake build
}

do_install () {
    # install ko and configs to rootfs
    install -d ${D}${datadir}/nxp_wireless
    cp -rf ${S}/bin_sd8997_bt ${D}${datadir}/nxp_wireless
}

FILES_${PN} = "${datadir}/nxp_wireless"

INSANE_SKIP_${PN} = "ldflags"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

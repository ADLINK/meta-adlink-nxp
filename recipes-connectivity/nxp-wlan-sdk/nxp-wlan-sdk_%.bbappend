DEPENDS = "virtual/kernel"
EXTRA_OEMAKE += " \
    KERNELDIR=${STAGING_KERNEL_BUILDDIR} \
"

require adlink-wlan-sdk_git.inc

do_compile_append () {
    # Change build folder to 8997 folder
    cd ${S}/mwifiex_8997

    export ARCH=arm64
    export CROSS_COMPILE=aarch64-poky-linux-

    oe_runmake build
}

do_install_append () {
   # install ko and configs to rootfs
   install -d ${D}${datadir}/nxp_wireless
   cp -rf ${S}/bin_sd8997 ${D}${datadir}/nxp_wireless
}

RDEPENDS_${PN} += " bash"


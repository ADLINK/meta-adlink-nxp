FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://0001-add-mlanutl-source-code.patch"

DEPENDS += "virtual/kernel"

do_compile:append () {
    # Change build folder to 8997 folder
    cd ${S}/wlan_src

    # export ARCH=arm64
    # export CROSS_COMPILE=aarch64-fsl-linux-

    oe_runmake build
}

do_install:append () {
   # install ko and configs to rootfs
   install -d ${D}${datadir}/nxp_wireless
   cp -rf ${S}/bin_wlan ${D}${datadir}/nxp_wireless
}

RDEPENDS:${PN} += " bash"


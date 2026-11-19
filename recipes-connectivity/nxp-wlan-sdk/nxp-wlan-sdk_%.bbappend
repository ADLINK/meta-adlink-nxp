FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# base patch if b1 support not set
SRC_URI:append = "${@bb.utils.contains('SUPPORT_LECIMX8MP_B1', '1', ' file://0001-LEC-IMX8MP-B1-Add-latest-wlan-external-driver.patch', ' file://0001-add-mlanutl-source-code.patch', d)}"

do_populate_lic[noexec] = "${@bb.utils.contains('SUPPORT_LECIMX8MP_B1', '1', '1', '0', d)}"

DEPENDS += "virtual/kernel"

B = '${@bb.utils.contains("SUPPORT_LECIMX8MP_B1", "1", "${S}", "${S}/wlan_src", d)}'

do_compile () {
    cd ${B}
    oe_runmake build
}

do_install () {
    install -d ${D}${datadir}/nxp_wireless
    cp -f -R --no-dereference --preserve=mode,links -v ${S}/bin_wlan ${D}${datadir}/nxp_wireless
    if [ "${SUPPORT_LECIMX8MP_B1}" = "1" ]; then
        install -d ${D}${datadir}/nxp_wireless/config
        install -m 0755 mapp/mlanutl/mlanutl ${D}${datadir}/nxp_wireless
        install -m 0755 script/load ${D}${datadir}/nxp_wireless
        install -m 0755 script/unload ${D}${datadir}/nxp_wireless
        install -m 0644 README_MLAN ${D}${datadir}/nxp_wireless
        install -m 0644 mapp/mlanconfig/config/* ${D}${datadir}/nxp_wireless/config
    fi
}

RDEPENDS:${PN} += " bash"


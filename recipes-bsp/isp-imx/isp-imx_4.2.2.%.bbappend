FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
file://0001-PATCH-isp-imx-imx678.patch \
"

do_install:append () {
    install -d ${D}/opt/imx8-isp/bin

    install -m 0755 ${S}/imx/run.sh ${D}/opt/imx8-isp/bin/
    install -m 0755 ${S}/imx/start_isp.sh ${D}/opt/imx8-isp/bin/
}


RDEPENDS:${PN} += "bash"

FILES_SOLIBS_VERSIONED:append = " ${libdir}/libimx678.so"

SYSTEMD_AUTO_ENABLE = "${@bb.utils.contains('IMAGE_FEATURES', 'imx678', 'disable', 'enable', d)}"

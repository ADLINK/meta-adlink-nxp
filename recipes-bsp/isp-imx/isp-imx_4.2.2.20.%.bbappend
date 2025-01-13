FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
file://0001-isp-imx-imx678.patch \
file://run.sh \
file://start_isp.sh \
"

do_install:append () {
    install -d ${D}/opt/imx8-isp/bin

    install -m 0755 ${WORKDIR}/run.sh ${D}/opt/imx8-isp/bin/
    install -m 0755 ${WORKDIR}/start_isp.sh ${D}/opt/imx8-isp/bin/
}


FILES_SOLIBS_VERSIONED:append = " ${libdir}/libimx678.so"


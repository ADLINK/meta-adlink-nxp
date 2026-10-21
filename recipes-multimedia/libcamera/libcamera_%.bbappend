FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-LEC-IMX95-Add-OV13855-support.patch \
    file://camera-preview.sh \
"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/sources/camera-preview.sh ${D}${bindir}/camera-preview.sh
}

FILES:${PN} += " \
    ${bindir}/camera-preview.sh \
"

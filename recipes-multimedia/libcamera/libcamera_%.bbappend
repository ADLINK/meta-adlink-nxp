FILESEXTRAPATHS:prepend:adlink-libcamera := "${THISDIR}/files:"

SRC_URI:append:adlink-libcamera = " \
    file://0001-LEC-IMX95-Add-OV13855-support.patch \
    file://camera-preview.sh \
"

do_install:append:adlink-libcamera() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/sources/camera-preview.sh ${D}${bindir}/camera-preview.sh
}

FILES:${PN}:append:adlink-libcamera = " \
    ${bindir}/camera-preview.sh \
"

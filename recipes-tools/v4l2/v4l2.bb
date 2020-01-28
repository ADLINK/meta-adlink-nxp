SUMMARY = "ADLINK v4l2 test application"
DESCRIPTION = "Camera RAW data capture tool"
LICENSE = "CLOSED"


SRC_URI = "\
    file://v4lcap\
    file://version\  	
"

S = "${WORKDIR}"

do_install() {
    install -d "${D}${bindir}"
    install -m 0755 "${WORKDIR}/v4lcap" "${D}${bindir}/v4lcap"
    install -m 0755 "${WORKDIR}/version" "${D}${bindir}/version"	
}

do_package_qa() {
}

FILES_${PN} += " ${bindir}/v4lcap ${bindir}/version"

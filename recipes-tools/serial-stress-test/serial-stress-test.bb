SUMMARY = "ADLINK serial stress test application"
DESCRIPTION = "serial loopback stress test tool"
LICENSE = "CLOSED"


SRC_URI = "\
    file://linux-serial-test \
"

S = "${WORKDIR}"

do_install() {
    install -d "${D}${bindir}"
    install -m 0755 "${WORKDIR}/linux-serial-test" "${D}${bindir}/linux-serial-test"
}

do_package_qa() {
}

FILES_${PN} += " ${bindir}/linux-serial-test"

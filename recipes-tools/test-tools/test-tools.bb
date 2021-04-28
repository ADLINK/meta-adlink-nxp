SUMMARY = "tools required for dqac testing"
LICENSE = "CLOSED"

SRC_URI = "\
	file://eltt2 \
	file://edid-decode \
	file://mbw \
	file://mdio-tool \
	file://spidev_fdx \
	file://spidev_test \
	file://USB31_TX_COMPLIANCE \
	file://USBTest \
	file://UTest.sh \
"

S = "${WORKDIR}"

do_install() {
    install -d -m 0755 ${D}/usr${base_bindir}
    install -m 0755 ${WORKDIR}/eltt2 ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/edid-decode ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/mbw ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/mdio-tool ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/spidev_fdx ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/spidev_test ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/USB31_TX_COMPLIANCE ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/USBTest ${D}/usr${base_bindir}/
    install -m 0755 ${WORKDIR}/UTest.sh ${D}/usr${base_bindir}/
}

do_package_qa() {
}

FILES_${PN} += " /usr${base_bindir}/eltt2"
FILES_${PN} += " /usr${base_bindir}/edid-decode"
FILES_${PN} += " /usr${base_bindir}/mbw"
FILES_${PN} += " /usr${base_bindir}/mdio-tool"
FILES_${PN} += " /usr${base_bindir}/spidev_fdx"
FILES_${PN} += " /usr${base_bindir}/spidev_test"
FILES_${PN} += " /usr${base_bindir}/USB31_TX_COMPLIANCE"
FILES_${PN} += " /usr${base_bindir}/USBTest"
FILES_${PN} += " /usr${base_bindir}/UTest.sh"
SUMMARY = "tools required for testing"
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

SRC_URI:append:lec-imx8mp = " \
	file://set_mac_address.c \
	file://hwbom_id.sh \
"

SRC_URI:append:lec-imx8mp-abb = " \
	file://restUartCfg.sh \
	file://rfkill-unblock-wifibt.sh \
	file://tlv320init.sh \
	file://alsa.cfg \
"

S = "${WORKDIR}"

do_compile_lec-imx8mp() {
	${CC} ${WORKDIR}/set_mac_address.c -o ${WORKDIR}/set_mac_address
}

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
 
do_install:append:lec-imx8mp() {
	install -m 0755 ${WORKDIR}/hwbom_id.sh ${D}/usr${base_bindir}/
	install -m 0755 ${WORKDIR}/set_mac_address ${D}/usr${base_bindir}/
}

do_install:append:lec-imx8mp-abb () {
        install -d ${D}${sysconfdir}/
        install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/restUartCfg.sh ${D}${sysconfdir}/init.d 
	install -m 0755 ${WORKDIR}/rfkill-unblock-wifibt.sh ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/tlv320init.sh ${D}${sysconfdir}/init.d
	install -m 0644 ${WORKDIR}/alsa.cfg ${D}${sysconfdir}/
	ln -sf ${D}/lib/bzip2/ptest/bzip2-tests/lbzip2 ${D}${bindir}/lbzip2
	ln -sf ${D}/usr/bin/lbzip2 ${D}${bindir}/lbunzip2 
	ln -sf ${D}/usr/bin/lbzip2 ${D}${bindir}/lbzcat
}

do_package_qa[noexec] = "1"

FILES_${PN} += " /usr${base_bindir}/eltt2"
FILES_${PN} += " /usr${base_bindir}/edid-decode"
FILES_${PN} += " /usr${base_bindir}/mbw"
FILES_${PN} += " /usr${base_bindir}/mdio-tool"
FILES_${PN} += " /usr${base_bindir}/spidev_fdx"
FILES_${PN} += " /usr${base_bindir}/spidev_test"
FILES_${PN} += " /usr${base_bindir}/USB31_TX_COMPLIANCE"
FILES_${PN} += " /usr${base_bindir}/USBTest"
FILES_${PN} += " /usr${base_bindir}/UTest.sh"
FILES_${PN}:append:lec-imx8mp = " /usr${base_bindir}/set_mac_address"
FILES_${PN}:append:lec-imx8mp = " /usr${base_bindir}/hwbom_id.sh"

RDEPENDS_${PN}:append:lec-imx8mp = "bash i2c-tools"


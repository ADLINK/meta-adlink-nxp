SUMMARY = "custom v4l2 multi plane application. Required for camera image capture"
LICENSE = "CLOSED"

SRC_URI = "\
    file://v4lcap_mplane.c \
"

S = "${WORKDIR}"

do_compile() {
	${CC} ${WORKDIR}/v4lcap_mplane.c -o ${WORKDIR}/v4lcap
}

do_install() {
    install -d -m 0755 ${D}${base_bindir}
    install -m 0755 ${WORKDIR}/v4lcap ${D}${base_bindir}/
}

do_package_qa() {
}

FILES:${PN} += "${base_bindir}/v4lcap"

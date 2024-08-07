SUMMARY = "custom v4l2 multi plane application. Required for camera image capture"
LICENSE = "CLOSED"

SRC_URI = "\
    file://v4lcap_mplane.c \
"

S = "${WORKDIR}"

do_compile() {
	${CC} ${WORKDIR}/v4lcap_mplane.c ${LDFLAGS} -o ${WORKDIR}/v4lcap
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${WORKDIR}/v4lcap ${D}${sbindir}/
}

FILES:${PN} += "${sbindir}/v4lcap"


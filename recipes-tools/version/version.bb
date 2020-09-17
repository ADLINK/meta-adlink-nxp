SUMMARY = "Compiles and installs executable to printout board name and BSP version"
LICENSE = "CLOSED"

SRC_URI = "\
    file://version.c \
"

S = "${WORKDIR}"

do_compile() {
	${CC} ${WORKDIR}/version.c -o ${WORKDIR}/version
}

do_install() {
    install -d -m 0755 ${D}/usr${base_bindir}
    install -m 0755 ${WORKDIR}/version ${D}/usr${base_bindir}/
}

do_package_qa() {
}

FILES_${PN} += " /usr${base_bindir}/version"

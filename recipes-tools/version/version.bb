SUMMARY = "Compiles and installs executable to printout board name and BSP version"
LICENSE = "CLOSED"

SRC_URI = "\
    file://version.c \
    file://lec-imx8mp_1v1.c \
"

S = "${WORKDIR}"

do_compile() {

if ${@bb.utils.contains('MACHINE', 'lec-imx8mp', 'true', 'false', d)}; then # LEC-i.MX8mp
	${CC} ${WORKDIR}/lec-imx8mp_1v1.c -o ${WORKDIR}/version
else
	${CC} ${WORKDIR}/version.c -o ${WORKDIR}/version
fi
}

do_install() {
    install -d -m 0755 ${D}/usr${base_bindir}
    install -m 0755 ${WORKDIR}/version ${D}/usr${base_bindir}/
}

do_package_qa() {
}

FILES_${PN} += " /usr${base_bindir}/version"

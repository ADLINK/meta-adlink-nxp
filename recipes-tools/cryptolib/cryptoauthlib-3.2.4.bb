SUMMARY = "Crypto authentication library"
DESCRIPTION = "Crypto authentication library"
LICENSE = "CLOSED"

SRC_URI = "\
	file://atecc-0.4.3_d13c10-arm64.tar.xz \
	file://cryptoauthlib-3.2.4-arm64.tar.xz \
"

S = "${WORKDIR}"

do_install() {
	install -d -m 0755 ${D}${bindir}
	install -m 0755 ${WORKDIR}/usr/bin/atecc-util ${D}${bindir}

	install -d -m 0755 ${D}${localstatedir}/lib/cryptoauthlib
	cp -R --no-preserve=ownership ${WORKDIR}/var/lib/cryptoauthlib/* ${D}${localstatedir}/lib/cryptoauthlib/

	install -d -m 0755 ${D}${libdir_native}
	install -m 0755 ${WORKDIR}/usr/lib/libcryptoauth.so ${D}${libdir_native}

	install -d -m 0655 ${D}${includedir}/cryptoauthlib
	cp -R --no-preserve=ownership ${WORKDIR}/usr/include/cryptoauthlib/* ${D}/${includedir}/cryptoauthlib/

	install -d -m 0755 ${D}${sysconfdir}/cryptoauthlib
	cp -R --no-preserve=ownership ${WORKDIR}/etc/cryptoauthlib/* ${D}${sysconfdir}/cryptoauthlib
}

do_package_qa() {
}

FILES_${PN}-dev += " ${includedir}/cryptoauthlib/"
FILES_${PN}-dev += " ${libdir_native}/libcryptoauth.so"
FILES_${PN} += " ${sysconfdir}/cryptoauthlib/"
FILES_${PN} += " ${localstatedir}/lib/cryptoauthlib/"
FILES_${PN} += " ${bindir}/atecc-util"

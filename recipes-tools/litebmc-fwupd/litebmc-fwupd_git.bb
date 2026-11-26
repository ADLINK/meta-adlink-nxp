SUMMARY = "ADLINK LiteBMC firmware flash utility"
DESCRIPTION = "Shows and updates the LiteBMC firmware over I2C (prebuilt binary)"
HOMEPAGE = "https://github.com/ADLINK/litebmc-fwupd"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/ADLINK/litebmc-fwupd.git;branch=main;protocol=https"
SRCREV = "0ffc9f5b5c4d77d95e1d8879360458fa362356fa"
PV = "1.0+git"

COMPATIBLE_HOST = "aarch64.*-linux"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/arm64/ad-litbmc-fwupd ${D}${bindir}/
}

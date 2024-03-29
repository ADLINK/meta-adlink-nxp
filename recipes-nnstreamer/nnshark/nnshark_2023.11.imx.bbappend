FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://common.tar.xz"

do_configure:prepend () {
  cp -r ${WORKDIR}/common/* ${S}/common
}

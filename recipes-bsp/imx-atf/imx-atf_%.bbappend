FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx8mp = " \
  file://0001-lec-imx8mp-Migrate-uart-log-port-from-MRAA-header-to.patch \
"

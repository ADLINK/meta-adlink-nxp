FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx8mp = " \
  file://0001-lec-imx8mp-Migrate-uart-log-port-from-MRAA-header-to.patch \
"

SRC_URI_append_lec-imx8mm = " \
  file://0001-Modify-UART4-peripherals-domain-permission-to-fix-ke.patch \
"

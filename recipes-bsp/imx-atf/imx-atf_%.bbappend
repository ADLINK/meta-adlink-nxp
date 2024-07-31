#EXTRA_OEMAKE:lec-imx8mp += 'IMX_BOOT_UART_BASE=${ATF_BOOT_UART_BASE}'

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx8mm = " \
  file://0001-Modify-UART4-peripherals-domain-permission-to-fix-ke.patch \
"

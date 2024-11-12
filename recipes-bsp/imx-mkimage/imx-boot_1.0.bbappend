FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " \
  file://0001-Added-DDR-config-binary-into-Image.patch \
"

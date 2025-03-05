FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " \
  file://0001-Added-lec-imx95-configuration.patch \
  file://0002-LEC-i.MX95-update-imx-sm-to-sync-1v2.0.12.patch \
"

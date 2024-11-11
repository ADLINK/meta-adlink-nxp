FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " \
  file://0001-Configure-DDR-Timings-based-on-Module-Ram-size.patch \
  file://0002-Added-linker-script.patch \
"

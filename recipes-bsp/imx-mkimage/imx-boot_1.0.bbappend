FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " \
  file://0001-Added-DDR-config-binary-into-Image.patch \
  file://0002-LEC-i.MX95-update-imx-mkimage-to-sync-1v2.0.12.patch \
"

do_replace () {
    bbnote "Modify soc.mak"
}
addtask replace before do_compile after do_configure


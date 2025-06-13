FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " \
  file://lec-imx95/0001-Added-DDR-config-binary-into-Image.patch \
  file://lec-imx95/0002-LEC-i.MX95-update-imx-mkimage-to-sync-1v2.0.12.patch \
"

do_replace () {
	bbnote "Modify soc.mak"
	sed -i 's|fdtoverlay.*|fdtoverlay -i $(dtbs) -o $(dtbs) signature.dtbo|g' ${BOOT_STAGING}/soc.mak
}
addtask replace before do_compile after do_configure


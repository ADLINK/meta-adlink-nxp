FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_IMXBOOT_PATCHES ?= ""
SRC_URI:append = " ${EXTRA_IMXBOOT_PATCHES}"

do_replace () {
	bbnote "Modify soc.mak"
	sed -i 's|fdtoverlay.*|fdtoverlay -i $(dtbs) -o $(dtbs) signature.dtbo|g' ${BOOT_STAGING}/soc.mak
}
addtask replace before do_compile after do_configure


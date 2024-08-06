do_replace:lec-imx8mp () {
	sed -i 's|dtbs = evk.dtb|dtbs = ${UBOOT_DTB_NAME}|g' ${BOOT_STAGING}/soc.mak
}

addtask do_replace:lec-imx8mp before do_compile after do_configure


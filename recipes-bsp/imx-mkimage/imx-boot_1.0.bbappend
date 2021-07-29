
do_replace () {
	sed -i 's|dtbs = evk.dtb|dtbs = ${UBOOT_DTB_NAME}|g' ${BOOT_STAGING}/soc.mak
}

addtask replace before do_compile after do_configure

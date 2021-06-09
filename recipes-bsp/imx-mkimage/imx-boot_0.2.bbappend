do_replace () {
	sed -i 's|dtbs = fsl-$(PLAT)-evk.dtb|dtbs = ${UBOOT_DTB_NAME}|g' ${BOOT_STAGING}/soc.mak
	sed -i 'N;s|yes)\nflash_evk: $(MKIMG)|yes)\nflash_ddr3l_evk: $(MKIMG) signed_hdmi_imx8m.bin u-boot-spl-ddr3l.bin u-boot.itb\n\t./mkimage_imx8 -fit -signed_hdmi signed_hdmi_imx8m.bin -loader u-boot-spl-ddr3l.bin $(SPL_LOAD_ADDR) -second_loader u-boot.itb 0x40200000 0x60000 -out $(OUTIMG)\n\nflash_evk: $(MKIMG)|g' ${BOOT_STAGING}/soc.mak
}

addtask replace before do_compile after do_configure

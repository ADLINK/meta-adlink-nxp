FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI:append = " \
  file://sdsd8997_combo_v4.bin \
"
do_install:append() { 
	
    install -m 0644 ${WORKDIR}/sdsd8997_combo_v4.bin ${D}${nonarch_base_libdir}/firmware/nxp


}

FILES:${PN}-nxp-common += " \
    ${nonarch_base_libdir}/firmware/nxp/sdsd8997_combo_v4.bin \
"

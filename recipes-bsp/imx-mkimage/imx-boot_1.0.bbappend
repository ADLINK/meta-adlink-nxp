# Copyright 2022-2023 ADLINK

do_replace () {
    sed -i 's|dtbs ?=.*|dtbs ?= ${UBOOT_DTB_NAME}|g' ${BOOT_STAGING}/soc.mak
    sed -i 's|fdtoverlay.*|fdtoverlay -i $(dtbs) -o $(dtbs) signature.dtbo|g' ${BOOT_STAGING}/soc.mak
    sed -i "s|^KEY_EXISTS.*|KEY_EXISTS=\$(sh -c 'if ls CRT\.\* \&> /dev/null 2>\&1; then echo exist; else echo noexist; fi')|g" ${BOOT_STAGING}/soc.mak
}
addtask replace before do_compile after do_configure

#
# modify imx-boot_1.0.bb to copy multiple uboot dtbs
#
do_compile:prepend() {
    strDTBS=$(echo "${UBOOT_DTB_NAME}" | xargs)
    DTBS=$(echo ${strDTBS} | awk -F' ' '{print NF}')
    if [ ${DTBS} -gt 1 ]; then
        bberror "Error: Do not specify more than 1 uboot dtb for imx-boot."
    fi
}

include ${@bb.utils.contains('MACHINE_FEATURES', 'stmm', 'prep-capsule.inc', '', d)}


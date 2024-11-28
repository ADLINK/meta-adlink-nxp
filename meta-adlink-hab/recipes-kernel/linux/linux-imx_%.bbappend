FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx-hab:${THISDIR}/../../recipes-bsp/imx-mkimage/imx-boot-hab:"

include ${@bb.utils.contains('IMAGE_FEATURES', 'hab', 'linux-imx-hab.inc', '', d)}


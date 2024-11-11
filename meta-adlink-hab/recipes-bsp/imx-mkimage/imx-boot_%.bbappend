FILESEXTRAPATHS:prepend := "${THISDIR}/imx-boot-hab:"

include ${@bb.utils.contains('IMAGE_FEATURES', 'hab', 'imx-boot-hab.inc', '', d)}


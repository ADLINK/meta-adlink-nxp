include ${@bb.utils.contains('IMAGE_FEATURES', 'logo', '${THISDIR}/../../../meta-adlink-demo/recipes-kernel/linux/customise-logo.inc', '', d)}


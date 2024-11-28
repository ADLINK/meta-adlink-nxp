UBOOT_EXTRA_CONFIGS:append = "${@bb.utils.contains('IMAGE_FEATURES', 'hab', ' IMX_HAB', '', d)}"


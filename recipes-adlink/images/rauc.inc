
python () {
    import bb
    machine = d.getVar("MACHINE")
    if machine != "lec-imx8mp":
        bb.warn("rauc is being used on MACHINE='%s', but it is only tested for 'lec-imx8mp'" % machine)
}


UBOOT_BOOT_SCRIPT = "${@bb.utils.contains('IMAGE_BASENAME', 'adlink-image-ums', 'boot.scr', 'abpart.scr', d)}"
IMAGE_BOOT_FILES += "${UBOOT_BOOT_SCRIPT}.uimg;boot.scr"

do_image_wic[depends] += "u-boot-script:do_install"

IMAGE_INSTALL:append = " adlinkrauc rauc u-boot-fw-utils"
PREFERRED_PROVIDER_u-boot-fw-utils = "libubootenv"

WKS_FILE = "adlink-imx8-imxboot-ab.wks.in"
WKS_PATH = "${THISDIR}/../../wic"

EXTRA_KERNEL_PATCHES += " file://lec-imx8mp/rauc.config \
"

DELTA_KERNEL_DEFCONFIG:append:lec-imx8mp = " rauc.config"


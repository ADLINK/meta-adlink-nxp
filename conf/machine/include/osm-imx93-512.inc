# ADLINK OSM-IMX93 with 512MB LPDDR4X
# Pulled in by local.conf when UBOOT_EXTRA_CONFIGS contains LPDDR4_512MB

KERNEL_DEVICETREE_BASENAME = "osm-imx93-512"

# kernel
EXTRA_KERNEL_DTS = " \
    file://osm-imx93/osm-imx93-512.dts \
    file://osm-imx93/osm-imx93-512-lvds-panel.dts \
"

# u-boot
UBOOT_DTB_NAME:osm-imx93 = "osm-imx93-512.dtb"


EXTRA_UBOOT_DTS = " \
    file://osm-imx93/osm-imx93-512.dts \
    file://osm-imx93/osm-imx93-u-boot.dtsi \
"
UBOOT_CONFIG_BASENAME = "imx93_osm_512"
EXTRA_UBOOT_PATCHES = " \
    file://0001-Added-Adlink-osm-imx93-Board-support.patch \
    file://0002-osm-imx93-relocate-ethosu-node-name-for-512MB.patch \
    file://0003-osm-imx93-512MB-LPDDR4X-timing.patch \
    file://osm-imx93/imx93_osm_512_defconfig \
"

# no OP-TEE on 512MB
MACHINE_FEATURES:remove = "optee"


EXTRA_KERNEL_PATCHES:append = " \
	file://lec-imx8mp/lec-imx8mp-r2.cfg \
	file://lec-imx8mp/0011-lec-imx8mp-R2-phy-led-and-edid-delay-support.patch \
	file://lec-imx8mp/0012-lec-imx8mp-R2-ov13855-reset-pin-cansleep.patch \
"

KERNEL_DEVICETREE_BASENAME = "lec-imx8mp-r2"

EXTRA_KERNEL_DTS = " \
	file://lec-imx8mp/lec-imx8mp-r2-auoB101UAN01-mipi-panel.dts \
	file://lec-imx8mp/lec-imx8mp-r2-hydis-hv150ux2.dts \
	file://lec-imx8mp/lec-imx8mp-r2.dts \
	file://lec-imx8mp/tlv320aic3x.dtsi \
	file://lec-imx8mp/lec-imx8mp-r2-tlv320aic3x.dts \
	file://lec-imx8mp/lec-imx8mp-r2-tlv320-lvds.dts \
	file://lec-imx8mp/lec-imx8mp-r2-auoG101EAT02p6-lvds-panel.dts \
"
WIFIBT_DTS = "${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'file://lec-imx8mp/lec-imx8mp-r2-wifi.dts', '', d)}"

EXTRA_UBOOT_PATCHES:append = " file://lec-imx8mp/adlink_lec8mpr2_defconfig"
UBOOT_CONFIG_BASENAME = "adlink_lec8mpr2"
UBOOT_CONFIG[fspi] = "${UBOOT_CONFIG_BASENAME}_defconfig"

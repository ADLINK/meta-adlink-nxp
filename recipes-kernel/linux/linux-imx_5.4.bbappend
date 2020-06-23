FSL_KERNEL_DEFCONFIG_IMX8m = "lec_imx8m_defconfig"


do_copy_defconfig() {

if ${@bb.utils.contains('TARGET_ARCH', 'aarch64', 'true', 'false', d)}; then # LEC-i.MX8m
    cp ${S}/arch/arm64/configs/${FSL_KERNEL_DEFCONFIG_IMX8m} ${B}/.config
    cp ${S}/arch/arm64/configs/${FSL_KERNEL_DEFCONFIG_IMX8m} ${B}/../defconfig
fi

}

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx8m += " \
			    file://0001-Fork-imx_v8_defconfig-to-create-lec_imx8m_defconfig.patch \
			    file://0002-Fork-imx8mq-evk-dts-to-create-adlink-lec-imx8m-dts.patch \
			    file://0003-Avoid-kernel-hang.patch \
			    file://0004-usdhc-sdslow-changes.patch \
			    file://0005-Add-cpuinfo-for-i.MX8M-variants.patch \
			    file://0006-buck2-pfuze100-regulator-changes.patch \
			    file://0007-Add-imx8m-1gb-2gb-module-support.patch \
			    file://0008-Add-uart2-support-and-changes-for-uart3.patch \
			    file://0009-pcie-pinctrl-modifications.patch \
			    file://0010-otg-peripheral-and-host-mode-support.patch \
			    file://0011-Add-support-for-pcal6416a-gpio-expander.patch \
			    file://0012-Add-Ethernet-ethphy0_DP83867_phy_support_and_complai.patch \
"

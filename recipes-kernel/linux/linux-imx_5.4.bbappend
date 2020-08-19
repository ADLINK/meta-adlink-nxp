FSL_KERNEL_DEFCONFIG_IMX6 = "lec_imx6_defconfig"
FSL_KERNEL_DEFCONFIG_IMX8m = "lec_imx8m_defconfig"


do_copy_defconfig() {

if ${@bb.utils.contains('TARGET_ARCH', 'arm', 'true', 'false', d)}; then # LEC-i.MX6
    cp ${S}/arch/arm/configs/${FSL_KERNEL_DEFCONFIG_IMX6} ${B}/.config
    cp ${S}/arch/arm/configs/${FSL_KERNEL_DEFCONFIG_IMX6} ${B}/../defconfig

fi

if ${@bb.utils.contains('TARGET_ARCH', 'aarch64', 'true', 'false', d)}; then # LEC-i.MX8m
    cp ${S}/arch/arm64/configs/${FSL_KERNEL_DEFCONFIG_IMX8m} ${B}/.config
    cp ${S}/arch/arm64/configs/${FSL_KERNEL_DEFCONFIG_IMX8m} ${B}/../defconfig
fi

}

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx6-1 += " \
			    file://0001-Fork-imx_v7_defconfig-to-create-lec_imx6_defconfig.patch \
			    file://0002-Fork-imx6q-dl-qp-sabresd-dts-to-create-lec-imx6q-s-q.patch \
			    file://0003-Add-UART-support.patch \
			    file://0004-Our-SD-MMC-interfaces-are-used-differently.patch \
			    file://0005-Improve-SD-MMC-power-consumption-and-speed.patch \
			    file://0006-Ethernet-is-subtly-different.patch \
			    file://0007-Adapt-HDMI-interface.patch \
			    file://0008-SATA-signal-parameters-can-be-tuned.patch \
			    file://0009-A-USB-hub-and-shared-power-enable-over-current-compl.patch \
			    file://0010-Add-pinmux-for-SDIO-power-enable-in-hog-group.patch \
			    file://0011-Enable-CAN-interfaces.patch \
			    file://0012-Add-SST-26VF064B-SPI-flash-support.patch \
			    file://0013-We-have-either-SPI0-or-I2S0-depending-on-mux.patch \
			    file://0014-Our-SPI-is-connected-differently.patch \
			    file://0015-Fix-and-streamline-TLV320AIC23-drivers.patch \
			    file://0016-Set-up-S-PDIF-in-out-ports.patch \
			    file://0017-Add-LVDS-support.patch \
			    file://0018-Add-Parallel-RGB-panel-support.patch \
			    file://0019-Solo_DualLite-lvds-parallel-RGB-specific-option.patch \
			    file://0020-Drop-EPDC-incl.-pinmux-and-regulator-from-Solo.patch \
			    file://0021-Our-PWM-backlight-has-an-enable-pin.patch \
			    file://0022-Add-misc-I2C-devices-specific-to-the-LEC-Base-R1-car.patch \
			    file://0023-Adapt-camera-interfaces.patch \
			    file://0024-Add-config-option-to-force-GEN1-speed.patch \
			    file://0025-Most-GPIOs-differ-clear-hog-misc.-pinmux-device.patch \
			    file://0026-Raise-default-thermal-trip-point-0-to-throttle-only-.patch \
			    file://0027-Add-DT-node-for-Media-Local-Bus-MLB.patch \
			    file://0028-Different-button-functions-on-GPIOs.patch \
			    file://0029-Add-option-to-activate-alternative-coda-VPU-driver.patch \
			    file://0030-Fix-suspend-to-RAM-issues.patch \
			    file://0031-Add-user-kernel-split-Kconfig-options-for-full-1-or-.patch \
			    file://0032-Add-instructive-comments-and-clarify-kernel-message-.patch \
			    file://0033-optimize-compile-when-6Q-SL-SX-UL-7D-support-is-disa.patch \
			    file://0034-We-don-t-need-stdout-path-in-chosen-node.patch \
			    file://0035-Change-copyright.patch \
"

SRC_URI_append_lec-imx6-2 += " \
                            file://0001-Fork-imx_v7_defconfig-to-create-lec_imx6_defconfig.patch \
                            file://0002-Fork-imx6q-dl-qp-sabresd-dts-to-create-lec-imx6q-s-q.patch \
                            file://0003-Add-UART-support.patch \
                            file://0004-Our-SD-MMC-interfaces-are-used-differently.patch \
                            file://0005-Improve-SD-MMC-power-consumption-and-speed.patch \
                            file://0006-Ethernet-is-subtly-different.patch \
                            file://0007-Adapt-HDMI-interface.patch \
                            file://0008-SATA-signal-parameters-can-be-tuned.patch \
                            file://0009-A-USB-hub-and-shared-power-enable-over-current-compl.patch \
                            file://0010-Add-pinmux-for-SDIO-power-enable-in-hog-group.patch \
                            file://0011-Enable-CAN-interfaces.patch \
                            file://0012-Add-SST-26VF064B-SPI-flash-support.patch \
                            file://0013-We-have-either-SPI0-or-I2S0-depending-on-mux.patch \
                            file://0014-Our-SPI-is-connected-differently.patch \
                            file://0015-Fix-and-streamline-TLV320AIC23-drivers.patch \
                            file://0016-Set-up-S-PDIF-in-out-ports.patch \
                            file://0017-Add-LVDS-support.patch \
                            file://0018-Add-Parallel-RGB-panel-support.patch \
                            file://0019-Solo_DualLite-lvds-parallel-RGB-specific-option.patch \
                            file://0020-Drop-EPDC-incl.-pinmux-and-regulator-from-Solo.patch \
                            file://0021-Our-PWM-backlight-has-an-enable-pin.patch \
                            file://0022-Add-misc-I2C-devices-specific-to-the-LEC-Base-R1-car.patch \
                            file://0023-Adapt-camera-interfaces.patch \
                            file://0024-Add-config-option-to-force-GEN1-speed.patch \
                            file://0025-Most-GPIOs-differ-clear-hog-misc.-pinmux-device.patch \
                            file://0026-Raise-default-thermal-trip-point-0-to-throttle-only-.patch \
                            file://0027-Add-DT-node-for-Media-Local-Bus-MLB.patch \
                            file://0028-Different-button-functions-on-GPIOs.patch \
                            file://0029-Add-option-to-activate-alternative-coda-VPU-driver.patch \
                            file://0030-Fix-suspend-to-RAM-issues.patch \
                            file://0031-Add-user-kernel-split-Kconfig-options-for-full-1-or-.patch \
                            file://0032-Add-instructive-comments-and-clarify-kernel-message-.patch \
                            file://0033-optimize-compile-when-6Q-SL-SX-UL-7D-support-is-disa.patch \
                            file://0034-We-don-t-need-stdout-path-in-chosen-node.patch \
                            file://0035-Change-copyright.patch \
			    file://0036-Disable-ldo-bypass-and-mmc1-for-imx6r2.patch \
			    file://0037-SD2_VSELECT_LOW.patch \
			    file://0038-Add-G133HAN01-Dual-Channel-LVDS-Support.patch \
			    file://0039-Add-SGTL5000-audio-codec-support.patch \
			    file://0040-Critical-and-passive-temperature-is-103-c.patch \
			    file://0041-SPI-Device-Node-Entry-corrected.patch \
			    file://0042-Do-not-disable-RTC-output-clock.patch \
"

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
			    file://0013-Add-external-thermal-sensor-support.patch \
			    file://0014-Add-sgtl5000-audio-codec-support.patch \
			    file://0015-Add-OV5640-mipi_csi-camera-support.patch \
			    file://0016-Add-rtc-rv3028-support.patch \
			    file://0017-Add-DSI-to-LVDS-panel-suppot.patch \
			    file://0018-Add-dual-display-support.patch \
			    file://0019-Add-MIPI-DSI-Panel-support.patch \
"

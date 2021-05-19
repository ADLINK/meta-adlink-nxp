FSL_KERNEL_DEFCONFIG_IMX6 = "lec_imx6_defconfig"
FSL_KERNEL_DEFCONFIG_IMX8m = "lec_imx8m_defconfig"
FSL_KERNEL_DEFCONFIG_IMX8mp = "lec-imx8mp_defconfig"

do_copy_defconfig() {

if ${@bb.utils.contains('TARGET_ARCH', 'arm', 'true', 'false', d)}; then # LEC-i.MX6
    cp ${S}/arch/arm/configs/${FSL_KERNEL_DEFCONFIG_IMX6} ${B}/.config
    cp ${S}/arch/arm/configs/${FSL_KERNEL_DEFCONFIG_IMX6} ${B}/../defconfig

elif ${@bb.utils.contains('MACHINE', 'lec-imx8mp', 'true', 'false', d)}; then # LEC-i.MX8mp
    cp ${S}/arch/arm64/configs/${FSL_KERNEL_DEFCONFIG_IMX8mp} ${B}/.config
    cp ${S}/arch/arm64/configs/${FSL_KERNEL_DEFCONFIG_IMX8mp} ${B}/../defconfig

elif ${@bb.utils.contains('TARGET_ARCH', 'aarch64', 'true', 'false', d)}; then # LEC-i.MX8m
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
			    file://0036-Change-SGTL5000-audio-codec-i2c-node-and-add-regualt.patch \
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
			    file://0043-Add-support-for-OV13850-camera-sensor.patch \
			    file://0044-Pad-register-changes-for-IMX6R2-A2-module.patch \
			    file://0045-Set-GPIO_0-EIM_A25-to-100K-ohm-pull-up.patch \
			    file://0046-Support-for-i.MX6R2-QP-module.patch \
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

SRC_URI_append_lec-imx8mp += " \
			file://0001-LEC-IMX8MP-Copy-from-i.MX8MP-EVK-for-building-LEC-iM.patch \
			file://0002-LEC-iMX8MP-Modify-Device-Tree-base-on-schematic-desi.patch \
			file://0003-LEC-IMX8MP-Enable-RTC-NXP-PCF8563-U2101.patch \
			file://0004-LEC-iMX8MP-Add-device-tree-node-of-Lite-BMC.patch \
			file://0005-LEC-iMX8MP-HYDIS-HV150UX2-LVDS-panel-support.patch \
			file://0006-LEC-iMX8MP-Add-support-of-MIPI-DSI-panel-AUO-B101UAN.patch \
			file://0007-LEC-iMX8MP-Enable-GPIO-expander-SX1509BIULTRT.patch \
			file://0008-LEC-IMX8MP-Enable-the-audio-function-by-correcting-t.patch \
			file://0009-LEC-iMX8MP-Add-support-of-TPM-chip-STMicroelectronic.patch \
			file://0010-LEC-iMX8MP-Add-support-of-Ethernet-PHY-DP83867-and.patch \
			file://0011-LEC-iMX8MP-Add-PCIe-Gen1-Tx-de-emphasis-for-passing.patch \
			file://0012-LEC-iMX8MP-Add-device-tree-settings-for-MIPI-CSI.patch \
			file://0013-LEC-iMX8MP-Adding-OV13850-sensor-support.patch \
			file://0014-LEC-iMX8MP-Use-CPU-temperatrue-grade-settings-for-th.patch \
			file://0015-LEC-iMX8MP-Add-Changes-for-new-camera-add-on-card.patch \
			file://0016-LEC-iMX8MP-Removing-pm_runtime-routines-from-hantro.patch \
			file://0017-LEC-iMX8MP-Change-USB-2-default-mode.patch \
			file://0018-LEC-iMX8MP-Enable-PCIE-compliance-test.patch \
			file://0019-LEC-iMX8MP-Changes-for-OV13855-camera-sensor.patch \
"

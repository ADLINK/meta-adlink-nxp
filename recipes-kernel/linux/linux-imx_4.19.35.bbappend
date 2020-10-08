DEFCONFIG	= "adlink_imx8qm_defconfig"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx8qm += " \
			file://0001-IMX8QM-Adlink-LEC-IMX8QM-base-commit.patch \
			file://0002-IMX8QM-Modify-Ethernet-Phy-Address.patch \
			file://0003-IMX8QM-Include-HDMI-dts-file.patch \
			file://0004-IMX8QM-Change-usbotg3-mode-to-host.patch \
			file://0005-IMX8QM-Disable-CAN-regulator.patch \
			file://0006-IMX8QM-TI-TMP102-DTS-configuration.patch \
			file://0007-IMX8QM-Add-support-for-SGTL5000-audio-codec.patch \
			file://0008-IMX8QM-Add-dts-file-for-ov5640.patch \
			file://0009-IMX8QM-Add-additional-resolution-for-DVI.patch \
			file://0010-IMX8QM-Additional-Changes-for-fec2-interface.patch \
			file://0011-IMX8QM-Fork-separate-dts-for-DVI.patch \
			file://0012-IMX8QM-Changes-for-SPIFlash-MX25UM.patch \
			file://0013-IMX8QM-Initial-LVDS-backlight-changes.patch \
			file://0014-IMX8QM-Restructing-ov5640-dts-changes.patch \
			file://0015-IMX8QM-Support-for-ov13850-camera-sensor.patch \
			file://0016-IMX8QM-Modified-Changes-for-SPIFlash-MX25UM-U5.patch \
			file://0017-IMX8QM-Changes-for-Single-Channel-LVDS.patch \
			file://0018-IMX8QM-Add-Bayer-RAW-format-in-capture-driver.patch \
"

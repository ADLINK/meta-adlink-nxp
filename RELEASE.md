# META-ADLINK-NXP BSP Layer Release Notes

## LEC-IMX8MP

### v1.7
2021-08-18

### Fixes
- Fix RDEPENDS packagegroup spelling mistake for wifi and bluetooth
- Add FCC specific mfg firmwares for nxp WIFI/BT sd8997 module
- Start the mfgbridge as an systemd service for adlink-image-fcc
- Fix inclusion of sema4.0 using full bsp meta-adlink-sema path
- set IO4 on ioexpander enable output on ethernet levelshift

### v1.6
2021-07-06

#### Features
- Increase CMA size to 512MB for displaying 1920x1080 HDMI video

### v1.5
2021-06-28

#### Features
- Add tool to set mac address in BMC
- Add wic template for building Adlink ums image
- Add lec-imx8mp u-boot patches based on u-boot 2020.04
- Enable U-BOOT configuration modification to set DDR size in u-boot-imx recipe
- Set preferred u-boot version to 2020.04
- Add u-boot bootscript to run ums command on eMMC
- Add adlink-image-ums image recipe
- Add patch to set CONFIG_MXMWIFIEX in kernel config
- Add device tree file for WIFI/BT module
- Add patch to build mxm_wifiex for nxp sdio 88w8997 WIFI/BT module
- Add patch for WIFI/BT firmware
- Add patch for WIFI/BT SDK
- Add patch for WIFI/BT kernel driver
- Split up tools/utilities using packagegroup-adlink-tools recipe
- Add personal access token for accessing private repository from ADLINK github
- Add mfgbridge tool for FCC verification
- Add adlink-image-fcc image recipe
- Add patch to reduce CMA size for headless systems, i.e. OVERRIDES_append=":tinycma"
- Add script to read HW/BOM ID
- Add script to turn on POWER LED (BMC_GREEN_LED)
- Add robotframework for contiuous integration image build

#### Fixes
- Disable x11 for vim build
- Modify MAC read tool
- Fix imx-mkimage 1.0 recipe to build u-boot 2020.04 customized u-boot device tree
- Add EXTRA_OEMAKE to set KERNELDIR to STAGING_KERNEL_BUILDDIR to fix kernel module build error
- Add missing sema util

### v1.4
2021-06-02

#### Features
- Read MAC address from BMC
- Change USB dr mode

### v1.3
2021-05-12

#### Features
- Enable PCI compliance
- Additional tools

#### FIXES
- Changes to OV13855 Camera sensor

### v1.2
2021-05-05

#### Features
- Add atecc cryto library (cryptoauthlib 3.2.4)
- Include ADLINK sema bsp layer
- Add Adlink startup service
- Add Adlink splash screen
- Add support for OV13855 Camera support
- Update distro and test tools
- Add MRAA ad dhcp package
- Include UMP library

##### Fixes
- System free during video playback and OTG
- Build issues

### v1.1
2021-03-27

#### Features
- Initial Commit and setup meta-adlink-bsp layer base on sumo branch
- Add base machine configuration file
- Add kernel patches to 5.4.70
- Add kernel config file
- Add version recipe
- Add weston 9.0.0 and weston init recipe
- Update local.conf and bblayer.conf files
- Add common tools/utilities to image



## LEC-IMX8M

### v3.2
2021-07-08

#### Features
- Add lec-imx8m u-boot patches based on u-boot 2018.03
- Set preferred u-boot version to 2018.03 in local.conf
- Enable U-BOOT configuration modification to set DDR size in u-boot-imx recipe
- Simplify linux-imx recipe for copying config and applying delta configs
- Enable mcp2517fd CAN Bus device

#### Fixes
- Backport u-boot 2018.03 recipe
- u-boot 2018.03 recipe duplicated installation of mkimage-uboot binary file
- Fix imx-mkimage 0.2 recipe to build u-boot 2018.03 customized u-boot device tree


This repo is dedicated to the NXP IMX-based modules. Here you can find the Yocto BSP recipes.

You can follow the same steps to build your own customized BSP based on your interests.

# 1. Supported Hardware

| Product    |                    Hardware Documentation                    |
| :--------- | :----------------------------------------------------------: |
| SP2-IMX8MP | [Click_here](https://www.adlinktech.com/Products/Panel_PCs_Monitors/Panel_PCs_Monitors/SP2-IMX8_Series?lang=en) |
| LEC-IMX8MP | [Click_here](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-IMX8MP?lang=en) |
| LEC-IMX8MM | [Click_here](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-IMX8MM?lang=en) |
| OSM-IMX93  | [Click_here](https://www.adlinktech.com/Products/Computer_on_Modules/OSM/OSM-IMX93)            |
| LEC-IMX95  | [click_here](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-IMX95)          |

# 2. Available Branches

1. [scarthgap](https://github.com/ADLINK/meta-adlink-nxp/tree/scarthgap)

2. [Mickledore](https://github.com/ADLINK/meta-adlink-nxp/tree/mickledore)

3. [Kirkstone](https://github.com/ADLINK/meta-adlink-nxp/tree/kirkstone)

4. [Hardkott](https://github.com/ADLINK/meta-adlink-nxp/tree/hardknott)

5. [Zeus](https://github.com/ADLINK/meta-adlink-nxp/tree/zeus)

6. [Sumo](https://github.com/ADLINK/meta-adlink-nxp/tree/sumo)

7. [Warrior](https://github.com/ADLINK/meta-adlink-nxp/tree/warrior)

# 3. Adlink Supported Patches

- Patches for the NXP-based products for the Adlink dev kit will be found [here](https://github.com/ADLINK/meta-adlink-nxp/tree/kirkstone/recipes-kernel/linux/linux-imx).
- The patches that we created and have are based on the NXP GitHub Kernel.
- This patch is based on kernel 5.15.x version.
> [!Note]
> Kernel version 5.15 onwards, Wi-Fi/BT interfaces are SDIO/UART.

# 4. Software Documentation

Refer to the [wiki](https://github.com/ADLINK/meta-adlink-nxp/wiki) page for instructions on building the Yocto as well as flashing the image.


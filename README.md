# Scarthgap

- Kernel version: 6.6.y
- Released year: 2024
- Kernel support by Adlink(continuing).
- Manifest of the Yocto BSP is [here](https://github.com/ADLINK/adlink-manifest).



## 1. Supported Recipes by Adlink

| Resources                      | Description |
| ------------------------------ | ----------- |
| conf                           |  Machine file and configuration files                                        |
| recipes-adlink                 |  Adlink tool recipes                                                         |
| recipes-bsp                    |  Bootloader related recipes                                                  |
| recipes-connectivity           |  Libraries and applications related to communication with other devices      |
| recipes-extended               |  Application which are not essentially but useful for testing and debugging  |
| recipes-fsl                    |  BB append files related to FSL receipe                                      |
| recipes-kernel                 |  Kernel related configuration changes and patches                            |
| recipes-multimedia             |  Codecs and support utilties for audio, images and video                     |
| recipes-nnstreamer/nnshark     |  nnstreamer related append file                                              |
| recipes-tools                  |  Adlink Related tools                                                        |
| wic                            |  Wic file for Image creation                                                 |



## 2. Supported Modules

- SP2-IMX8MP

## 3. Supported Features & Interfaces

### 3.1 SP2-IMX8MP (SBC + LVDS/MIPI-DSI display panels)

| Interfaces                                 | Support |
| ------------------------------------------ | ------- |
| RAM [LPDDR4(2G/4G/8G)]                     | Y       |
| MIPI-DSI [7", 7"RLCD]                      | Y       |
| LVDS [7", 10"]                             | Y       |
| GPU                                        | Y       |
| VPU                                        | Y       |
| HDMI                                       | Y       |
| eMMC                                       | Y       |
| Debug Header                               | Y       |
| Audio [sgtl5000]                           | Y       |
| Ethernet - 0 & 1                           | Y       |
| Wi-Fi(optional) [Azurewave AW-CM276MA]     | Y       |
| Bluetooth(optional) [Azurewave AW-CM276MA] | Y       |
| PCIe                                       | Y       |
| USB 2.0/3.0                                | Y       |
| SER                                        | Y       |
| CAN                                        | Y       |
| SPI                                        | Y       |
| I2S                                        | Y       |
| I2C                                        | Y       |
| GPIO                                       | Y       |
| SDIO                                       | Y       |

## 4. Documentation

Refer to the [wiki](https://github.com/ADLINK/meta-adlink-nxp/wiki) page for instructions on building the Yocto as well as flashing the image.


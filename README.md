<img src="https://www.linaro.org/assets/images/projects/yocto-project.png" width="200" align="right">
<br>

### Supported Hardware List

|                         SMARC Module                         | Description                                                  | Yocto Images with zeus                                       |
| :----------------------------------------------------------: | :----------------------------------------------------------- | ------------------------------------------------------------ |
| <img src="https://cdn.adlinktech.com/webupd/products/images/1752/LEC-iMX8M-F_(1)_web.jpg" width="200"/> | **LEC-iMX8M** ([More details](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-iMX8M?lang=en))  <br />     SMARC Short Size Module with NXP i.MX 8M<br /> | [click here](https://github.com/ADLINK/meta-adlink-nxp/blob/zeus/README.md#lec-imx8m-smarc-module) |
| <img src="https://cdn.adlinktech.com/webupd/products/images/1838/LEC-iMX6R2-F_web.png" alt="img" width="200" /> | **LEC-iMX6R2** ([More details](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-iMX6R2?lang=en))  <br />     SMARC Short Size Module with NXP i.MX 6 Multicore Arm® Cortex®-A9<br /> | [click here](https://github.com/ADLINK/meta-adlink-nxp/blob/zeus/README.md#lec-imx6r2-smarc-module) |
| <img src="https://cdn.adlinktech.com/webupd/products/images/1344/LEC-iMX6_20171201_v2.jpg" alt="img" width="200" /> | **LEC-iMX6** ([More details](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-iMX6?lang=en))  <br />    SMARC Short Size Module with Freescale i.MX6 Solo, DualLite, Dual or Quad Core Processor<br /> | [click here](https://github.com/ADLINK/meta-adlink-nxp/blob/zeus/README.md#lec-imx6-smarc-module) |

<br>

#### How to build Yocto Image

* see [documentation](https://github.com/ADLINK/meta-adlink-nxp/wiki/01.-Build-Yocto-Image) for more details.

#### How to flash image to your storage**

* [Boot from SD card](https://github.com/ADLINK/meta-adlink-nxp/wiki/03.-How-to-install-Yocto-Image-into-SD-Card)

<br>

<br> 



### LEC-iMX8M SMARC Module

|                         SMARC Module                         | Description                                                  |
| :----------------------------------------------------------: | :----------------------------------------------------------- |
| <img src="https://cdn.adlinktech.com/webupd/products/images/1752/LEC-iMX8M-F_(1)_web.jpg" width="200"/> | **LEC-iMX8M** ([More details](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-iMX8M?lang=en))  <br />     SMARC Short Size Module with NXP i.MX 8M<br /> |

**SD Card image (64bit) for the quick evaluation**

* NXP i.MX8M 4G Memory with Wayland Weston Desktop (carrier board: [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en)): [ link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX8M/Yocto/LEC-iMX8M-4G-LEC-BASE2.0_weston_sd_3v1_20200717.zip)
* NXP i.MX8M 2G Memory with Wayland Weston Desktop (carrier board: [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en)): [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX8M/Yocto/LEC-iMX8M-2G-LEC-BASE2.0_weston_sd_3v1_20200717.zip)
* NXP i.MX8M 1G Memory with Wayland Weston Desktop (carrier board: [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en)): [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX8M/Yocto/LEC-iMX8M-1G-LEC-BASE2.0_weston_sd_3v1_20200717.zip)

<br>

**Supported features & interfaces**

* Linux Kernel version: 5.4.3
* UART ports: COM0, COM1, COM2 on [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en)
* 2x USB 2.0 + 2x USB 3.0
* HDMI output 
* Audio & speaker
* Support MIPI CSI Camera with 2 Lane : OV5640 Camera module
* Support AUO B101UAN0 MIPI DSI panel with the resolution up to 1920x1200 (BOM change is required)  
* Support AUO G133HAN01 LVDS panel with 1920x1080 Dual 24bit
* Support 10B/100MB/1GB Ethernet port
* eMMC/SD card support
* PCIe Gen2 support
* Support the following Video Codec:
   * 4Kp60 HEVC/H.265 main, and main 10 decoder
   * 4Kp30 AVC/H.264 decoder
   * 1080p60 MPEG-2, MPEG-4 



<br>

<br>

### LEC-iMX6R2 SMARC Module

|                         SMARC Module                         | Description                                                  |
| :----------------------------------------------------------: | :----------------------------------------------------------- |
| <img src="https://cdn.adlinktech.com/webupd/products/images/1838/LEC-iMX6R2-F_web.png" alt="img" width="200" /> | **LEC-iMX6R2** ([More details](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-iMX6R2?lang=en))  <br />     SMARC Short Size Module with NXP i.MX 6 Multicore Arm® Cortex®-A9<br /> |

**SD Card image (32bit) for the quick evaluation**

| Module supported                                             |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| NXP i.MX6R2 Quad & Dual with 2GB memory + [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6R2/Images/Yocto/LEC-iMX6R2-2GQ-LEC-BASE2.0-Yocto-Zeus-sdcard-2v1-20200925.zip) |
| NXP i.MX6R2 Quad & Dual with 1GB memory + [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6R2/Images/Yocto/LEC-iMX6R2-1GQ-LEC-BASE2.0-Yocto-Zeus-sdcard-2v1-20200925.zip) |
| NXP i.MX6R2 Solo & Dual Lite with 2GB memory + [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6R2/Images/Yocto/LEC-iMX6R2-2GS-LEC-BASE2.0-Yocto-Zeus-sdcard-2v1-20200925.zip) |
| NXP i.MX6R2 Solo & Dual Lite with 1GB memory + [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6R2/Images/Yocto/LEC-iMX6R2-1GS-LEC-BASE2.0-Yocto-Zeus-sdcard-2v1-20200925.zip) |
| NXP i.MX6R2 Quad Plus with 4GB memory + [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6R2/Images/Yocto/LEC-iMX6R2-4GQP-LEC-BASE2.0-Yocto-Zeus-sdcard-2v1-20200925.zip) |
| NXP i.MX6R2 Dual Lite with 512MB memory + [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-BASE_2_0?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6R2/Images/Yocto/LEC-iMX6R2-512M-LEC-BASE2.0-Yocto-Zeus-sdcard-2v1-20200925.zip) |

<br>

**Supported features & interfaces**

* UART ports: COM0, COM1, COM2, COM3 on [LEC-BASE 2.0](https://www.adlinktech.com/Products/Computer_on_Modules/SMARCCarrierBoards/LEC-BASE_R1?lang=en)

* 4x USB 2.0 + 1x USB OTG

* HDMI output 

* Support LVDS panel with Dual-channel 24bit

* Audio & speaker

* eMMC/SD card support

* MIPI CSI camera 4 Lanes

* PCIe Gen2 support

* Support 10B/100MB/1GB Ethernet port

* Support 1x SATA, 12x GPIO (PCA9535), 2x SPI, 3x I2C, 2x CANBus,

* Support Ethernet

* Support the following Video Codec:

  * 1080p60 HEVC/H.265 decoder

  * 1080p60 AVC/H.264 decoder

  * 1080p60 MPEG-2, 1080p30 MPEG-4  decoder

  * 1080p30 VP8 decoder

  * 1080p60 VC-1 decoder

    

<br>

<br>

### LEC-iMX6 SMARC Module

|                         SMARC Module                         | Description                                                  |
| :----------------------------------------------------------: | :----------------------------------------------------------- |
| <img src="https://cdn.adlinktech.com/webupd/products/images/1344/LEC-iMX6_20171201_v2.jpg" alt="img" width="200" /> | **LEC-iMX6** ([More details](https://www.adlinktech.com/Products/Computer_on_Modules/SMARC/LEC-iMX6?lang=en))  <br />    SMARC Short Size Module with Freescale i.MX6 Solo, DualLite, Dual or Quad Core Processor<br /> |

**SD Card image (32bit) for the quick evaluation**

| Module supported                                             |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| NXP i.MX6 Quad & Dual with 2GB memory + [LEC BASE R1](https://www.adlinktech.com/Products/Computer_on_Modules/SMARCCarrierBoards/LEC-BASE_R1?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6/Images/Yocto/LEC-iMX6-2GQ-LEC-BASER1-Yocto-Zeus-sdcard-1v1-20201012.zip) |
| NXP i.MX6 Quad & Dual with 1GB memory + [LEC BASE R1](https://www.adlinktech.com/Products/Computer_on_Modules/SMARCCarrierBoards/LEC-BASE_R1?lang=en)carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6/Images/Yocto/LEC-iMX6-1GQ-LEC-BASER1-Yocto-Zeus-sdcard-1v1-20200925.zip) |
| NXP i.MX6 Dual Lite with 2GB memory + [LEC BASE R1](https://www.adlinktech.com/Products/Computer_on_Modules/SMARCCarrierBoards/LEC-BASE_R1?lang=en) carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6/Images/Yocto/LEC-iMX6-2GS-LEC-BASER1-Yocto-Zeus-sdcard-1v1-20201012.zip) |
| NXP i.MX6 Solo with 1GB memory + [LEC BASE R1](https://www.adlinktech.com/Products/Computer_on_Modules/SMARCCarrierBoards/LEC-BASE_R1?lang=en)carrier board and support Wayland Weston | [link](https://hq0epm0west0us0storage.blob.core.windows.net/public/SMARC/LEC-iMX6/Images/Yocto/LEC-iMX6-1GS-LEC-BASER1-Yocto-Zeus-sdcard-1v1-20200925.zip) |



**Supported features & interfaces**

* UART ports: COM0, COM1, COM2, COM3 on [LEC BASE R1](https://www.adlinktech.com/Products/Computer_on_Modules/SMARCCarrierBoards/LEC-BASE_R1?lang=en)

* 2x USB 2.0 + 1x USB OTG

* HDMI output 

* Support MIPI CSI Camera with 2 Lane

* Support LCD panel with EIZO EV2455

* Support LVDS panel with single channel 24bit

* Audio & speaker

* eMMC/SD card support

* PCIe Gen1 support

* Support 1x SATA, 12x GPIO (PCA9535), SPI, I2C, 2x CANBus

* Support 10B/100MB/1GB Ethernet port

* SEMA 3.5 support

* Support the following Video Codec:

  * 1080p60 HEVC/H.265 decoder

  * 1080p60 AVC/H.264 decoder

  * 1080p60 MPEG-2, 1080p30 MPEG-4  decoder

  * 1080p30 VP8 decoder

  * 1080p60 VC-1 decoder

    

<br />

**How to build Yocto Image**

* see [documentation](https://github.com/ADLINK/meta-adlink-nxp/wiki/01.-Build-Yocto-Image) for more details.

**How to flash image to your storage**

* [Boot from SD card](https://github.com/ADLINK/meta-adlink-nxp/wiki/03.-How-to-install-Yocto-Image-into-SD-Card)

 

<br>

Please feel free to send us (email: ryanzj.huang@adlinktech.com) patches for this layer or report any bugs found in this layer. 
<br> For hardware support, please contact your local representative.

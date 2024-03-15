# RELEASE NOTE

## SP2-IMX8MP

### Overview

This document describes Yocto/NXP-Desktop BSP for SP2-IMX8MP board.

| Software          | Version         |
| ----------------- | --------------- |
| U-boot            | 2022.04         |
| Kernel            | 5.15.71         |
| Yocto/NXP-Desktop | 4.0 (Kirkstone) |

### Yocto BSP Build Info

Build Configuration:
BB_VERSION           = "2.0.0"
BUILD_SYS            = "x86_64-linux"
NATIVELSBSTRING      = "universal"
TARGET_SYS           = "aarch64-fsl-linux"
MACHINE              = "sp2-imx8mp"
DISTRO               = "imx-desktop-xwayland"
DISTRO_VERSION       = "1.0"
TUNE_FEATURES        = "aarch64 armv8a crc crypto"
TARGET_FPU           = ""
meta                 
meta-poky            = "HEAD:24a3f7b3648185e33133f5d96b184a6cb6524f3d"
meta-oe              
meta-multimedia      
meta-python          = "HEAD:4b291a478cf142dc9e04ee23a351603927b715a5"
meta-freescale       = "HEAD:c82d4634e7aba8bc0de73ce1dfc997b630051571"
meta-freescale-3rdparty = "HEAD:5977197340c7a7db17fe3e02a4e014ad997565ae"
meta-freescale-distro = "HEAD:d5bbb487b2816dfc74984a78b67f7361ce404253"
meta-bsp             
meta-sdk             
meta-ml              
meta-v2x             = "HEAD:9174c61f4dc80b14e0bfdaec9200ed58fb41615f"
meta-nxp-demo-experience = "HEAD:52eaf8bf42f8eda2917a1c8c046003c8c2c8f629"
meta-chromium        = "HEAD:e232c2e21b96dc092d9af8bea4b3a528e7a46dd6"
meta-clang           = "HEAD:c728c3f9168c8a4ed05163a51dd48ca1ad8ac21d"
meta-gnome           
meta-networking      
meta-filesystems     = "HEAD:4b291a478cf142dc9e04ee23a351603927b715a5"
meta-qt6             = "HEAD:ed785a25d12e365d1054700d4fc94a053176eb14"
meta-virtualization  = "HEAD:9482648daf0bb42ff3475e7892542cf99f3b8d48"
meta-nxp-desktop     = "HEAD:5f5bfd21c445eaa2d963d4b606d9ef56078eab8f"
meta-adlink-demo     = "HEAD:ccb701ba1a7d88487632a5d450e38a8937adf9ee"
meta-adlink-nxp      = "HEAD:99092a281d58c7bc0ee6b30b18bf4f3fc8593448"
meta-xfce            = "HEAD:4b291a478cf142dc9e04ee23a351603927b715a5"



### Version History

---

15th March 2024

Build #207

Release: Tagged Version: v1.00.03

Changes:

Yocto BSP:

1. Upload changes to u-boot and kernel as patches to meta-adlink-nxp meta-layer
2. Clean up and up stream meta-adlink-nxp, and meta-adlink-demo, to official github
3. Build image from official github yocto project settings

Fixes:

1. Fix WoL on Eth1
2. Fix Bluetooth A2DP audio baudrate issue



---

3rd March 2024

Build #199

Changes:

1. Enable 950MB, 750MB, 415MB CMA eeprom configuration for Video Testing.
2. Enable Ethernet BOM option in eeprom configuration.
3. Enable Wake on LAN on Ethernet Ports.
4. Add LVDS display support in U-boot for showing ADLINK Logo.
5. Add MIPI-DSI display support in U-boot for showing ADLINK Logo.
6. Enable uboot to load ADLINK Logo from splashimage.bmp file.
7. Enable i2c eeprom reading early in boot process for config parsing
8. Enable BLOBLIST and HANDOFF in SPL to pass detected DRAM size to U-Boot

Fixes:

1. Revert to default SPI device for testing

Known Issues:

1. Auto-negotiation on Eth1 port disabled due to WoL.



---

29th Jan 2024

Build #173

Changes:

1. Enable mlanutl binary (build from src code) for WIFI Testing.



---

5th Jan 2024

Build #146

Release: Tagged Version: v1.0.2

Fixes:

1. Modified msgpacker.py to read/write 53# 95# number as string
   
   NOTE: Future releases will focus on fine tuning, and additional software features.



---

22nd Dec 2023

Build #136

Changes:

1. Added glmark2 3D demo test tool

Fixes:

1. RTS/CTS configuration for UART4.

2. 8GB LPDDR4 support.

3. Fix Accidental Removal of SPI device configuration.

4. Enable MIPI-DSI ili9881c panel support.

5. Remove software tracker/tracker-extract/tracker-miner (which crashes repeatedly, journalctl -f to see the logs)



---

11th Dec 2023

Build #116

Changes:

1. USB ID detection for USB Dual Role Switch.
   
   USB cable plugged-in, is device mode (eMMC emulated as mass storage device).
   
   USB cable plugged-out, is host mode (usb-mux switch back to USB3.0 port).

2. Audio Codec Route Map updated.
   
   Use Ext Spk instead of Line Out Jack.
   
   Audio Jack Gpio pin detected.
   
   Audio Jack plugged in, NXP device generate Headphone Device.
   
   Audio Jack plugged out, NXP device switch back to Audio build-in output.

3. Load a default profile for ALSA mixer at boot, i.e. Ext Spk (Line-Out) is unmuted when boot up.

4. msgpacker.py script added new functions, i.e. set,get, remove, see DVT report in excel.

5. LVDS Panel timing, patched kernel lvds (panel-lvds.c) driver, to add delays to match required timing.

Fixes:

1. LED on Ethernet Port Connector.
   
   Left LED is speed indicator.
   
   Right LED is link/activity indicator.



---

9th Nov 2023

Build #91

Changes:

1. Add ffmpeg (commercial license) to allow mp4 video playback.

2. Enable SDIO WIFI/BT card (aw-cm276ma-sur).
   
   NOTE: must config "wl": "sur" in eeprom to enable SDIO WIFI/BT card.

3. Re-map ioexpander DI/DOs to libgpiod controllable pin-names.
   
   NOTE: No need to use i2c commands to control ioexpander DI/DOs anymore.



---

1st Nov 2023

Build #85

Changes:

1. Enable Bluetooth over uart0 (/dev/ttymxc0).

2. Tune CPU tripping temperature to 105/100 degC.

Yocto Image with build info:

1. To check image build info, issue command # cat /etc/build.



---

30th Oct 2023

Build #70

Changes:

1. UART3 (/dev/ttymxc2) and UAR4 (/dev/ttymxc3) enabled.
   
   a. UART3 is RS485 only.
   
   b. UART4 is multi-function enabled.
   
   c. use uart-mode.sh bash script to set correct UART_MODE pins.

Fixes:

1. SGTL5000 audio codec driver (disable charge pump and max voltage output) to enable Audio Line-Out.



---

24th Oct 2023

Build #62

Fixes:

1. Power Sequence for 7inch LVDS Panel (use panel-simple.c driver instead of panel-lvds.c).

2. SGTL5000, audio output to headphone ready, mic recording ready.

3. set usb3 tx-vboost-lvl amplitude to 1.04v.

Known Issues:

1. Still need to enable Line-Out to speaker.



---

19th Oct 2023

Build #56

Changes:

1. Enable parsing msgpack-formatted setting in EEPROM in u-boot.
   
   So as to device tree overlay for 10inch panel.

2. 10inch panel is enabled.

Fixes:

1. Replace Ubuntu DRM libraries with Yocto built ones. DRM tools, e.g. modetest, is working now.

2. Tune PCIe output signal strength.



---

13th Oct 2023

Build #37

Changes:

1. 7inch and HDMI dual display are enabled. Default as dual display.

2. Enable msgpack reading in uboot (uboot command: jsinfo), able to read MSGPACK formatted eeprom.



---

6th Oct 2023

Build #33

Changes:

Yocto Image with SI tool:

1. USB_Linux_HSET

2. mdio-tool

3. mdio-tool-scripts

4. memtool

Yocto Image with DVT tools:

1. usbutils

2. spi-tools

3. i2c-tools

4. memtool

5. dosfstools

6. evtest

7. e2fsprogs

8. fbset

9. iproute2

10. libgpiod2

11. memtester

12. python3

13. ethtool

14. mtd-utils

15. procps

16. ptpd

17. linuxptp

18. iw

19. can-utils

20. cpufrequtils

21. nano

22. ntpdate

23. minicom

24. coreutils

25. mmc-utils

26. udev

27. pciutils

28. hdparm

29. htop

30. mbw

31. stress-ng

32. x11-xserver-utils

33. alsa-utils

34. tpm2-tools

35. putty

36. gtkterm

37. f3

38. fancontrol

39. lm-sensors

40. modemmanager

41. msgpacker

42. edid-decode

43. imx-test

Known Issues:

1. linux-serial-test not included



---

5th Oct 2023

build #30

Changes:

Yocto Image with SI tool:

1. USB_Linux_HSET.

2. mdio-tool.

Known Issues:

1. Still missing memtool.

2. LVDS panel brought up (But HDMI temporary switched off).



---

3rd Oct 2023

Build #12

Changes:

1. Enable 2GB LPDDR4 in u-boot.

2. Enable 4GB LPDDR4 in u-boot.

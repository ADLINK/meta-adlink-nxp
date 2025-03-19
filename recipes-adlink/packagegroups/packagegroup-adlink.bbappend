RDEPENDS:packagegroup-adlink-wifi:append:lec-imx8mp = " \
    linux-firmware-nxp8997-sdio \
    linux-firmware-nxp8997-common \	
    nxp-wlan-sdk \
    wireless-tools \
    firmware-nxp-wifi \
"

RDEPENDS:packagegroup-adlink-tools:append:lec-imx8mp = " \
    powerled \
    eth-lsoe \
    v4lcap-mplane \
"


RDEPENDS:packagegroup-adlink-bluetooth:append:lec-imx8mm = " \
    kernel-module-bt-sd8997 \
"

RDEPENDS:packagegroup-packagegroup-adlink-tools:append:lec-imx8mm  = " \
    powerled \
    eth-lsoe \
    test-tools \
"

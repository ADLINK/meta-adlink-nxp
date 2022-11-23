RDEPENDS_packagegroup-adlink-wifi:append:lec-imx8mp = " \
    linux-firmware-nxp89xx \
    kernel-module-nxp89xx \
    nxp-wlan-sdk \
    wireless-tools \
"

RDEPENDS_packagegroup-adlink-tools:append:lec-imx8mp = " \
    powerled \
    eth-lsoe \
    test-tools \
    v4lcap-mplane \
"

RDEPENDS_packagegroup-adlink-bluetooth:append:lec-imx8mp = " \
    kernel-module-bt-sd8997 \
    linux-firmware-sd8997 \
"

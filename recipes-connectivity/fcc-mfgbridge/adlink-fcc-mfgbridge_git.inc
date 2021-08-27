SUMMARY = "NXP Wifi/BT mfgbridge for FCC equipment setup for SDIO 88w8997 and 88w8987"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://bridge_linux_0.1.0.43/bridge/README.txt;md5=2f85dc28e3af185e0f821e92f8bb49be;"

ADLINK_SRC ?= "git://github.com/ADLINK/mwifiex-adlink.git"

SRCBRANCH = "adlink-bridge-0.1.0.43"
SRC_URI = "${ADLINK_SRC};branch=${SRCBRANCH};protocol=https;user=${PA_USER}:${PA_TOKEN};"
SRCREV = "2e2c7e0a1d5b733aa5398c6d3e6cc57dd68b8f52"

S = "${WORKDIR}/git"


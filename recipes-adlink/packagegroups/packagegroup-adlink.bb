# Copyright 2021 ADLINK
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "ADLINK packagegroup for packacking tools for all ADLINK Distributions"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES = "packagegroup-adlink \
            packagegroup-adlink-imx \
            packagegroup-adlink-sensors \
            packagegroup-adlink-benchmarks \
            packagegroup-adlink-wifi \
            packagegroup-adlink-bluetooth \
            packagegroup-adlink-tools \
            packagegroup-adlink-utils \
            packagegroup-adlink-debug \
            packagegroup-adlink-ci \
            packagegroup-adlink-net \
            packagegroup-adlink-bios \
"

#
# packagegroup-adlink contain stuff needed for adlink build images
#
RDEPENDS:packagegroup-adlink = " \
    packagegroup-adlink-tools \
    packagegroup-adlink-net \
    ${@bb.utils.contains('DISTRO_FEATURES', 'sensors', 'packagegroup-adlink-sensors', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'benchmarks', 'packagegroup-adlink-benchmarks', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'wifi', 'packagegroup-adlink-wifi', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'bluetooth', 'packagegroup-adlink-bluetooth', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'utils', 'packagegroup-adlink-utils', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'debug', 'packagegroup-adlink-debug', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'ci', 'packagegroup-adlink-ci', '', d)} \
    ${@bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', 'packagegroup-adlink-imx', '', d)} \
"

#
# packages added by imx-image-core for tests
#
SUMMARY:packagegroup-adlink-imx = "Imx Tools Support"
RDEPENDS:packagegroup-adlink-imx = " \
    imx-test \
    firmwared \
    packagegroup-core-full-cmdline \
    packagegroup-tools-bluetooth \
    packagegroup-fsl-tools-audio \
    packagegroup-fsl-tools-gpu \
    packagegroup-fsl-tools-gpu-external \
    packagegroup-fsl-tools-testapps \
    packagegroup-fsl-tools-benchmark \
    packagegroup-fsl-gstreamer1.0 \
    packagegroup-fsl-gstreamer1.0-full \
    packagegroup-imx-core-tools \
    packagegroup-imx-isp \
    packagegroup-imx-security \
"

#
# packages added by adlink sensors
#
SUMMARY:packagegroup-adlink-sensors = "Adlink Sensors Support"
RDEPENDS:packagegroup-adlink-sensors = " \
    lmsensors-fancontrol \
    lmsensors-libsensors \
    lmsensors-pwmconfig \
    lmsensors-sensord \
    lmsensors-sensors \
    lmsensors-sensorsconfconvert \
    lmsensors-sensorsdetect \
"

SUMMARY:packagegroup-adlink-benchmarks = "Adlink Benchmarks Support"
RDEPENDS:packagegroup-adlink-benchmarks = " \
    glmark2 \
    memtester \
    fio \
    iozone3 \
    lmbench \
    stress-ng \
    stressapptest \
    sysbench \
    phoronix-test-suite \
"

RDEPENDS_GROUP_EXTRA_WIFI ?= ""


#
# packages added by adlink tools for wifi
#
SUMMARY:packagegroup-adlink-wifi = "Adlink wifi Support"
RDEPENDS:packagegroup-adlink-wifi = " \
    iperf3 \
    iw \
    rfkill \
    connman \
    wpa-supplicant \
    dhcpcd \
    kea \
    hostapd \
    ${RDEPENDS_GROUP_EXTRA_WIFI} \
"

#
# packages added by adlink tools for bluetooth
#
SUMMARY:packagegroup-adlink-bluetooth = "Adlink bluetooth Support"
RDEPENDS:packagegroup-adlink-bluetooth = " \
    rfkill \
    bluez5 \
"

#
# packages added by adlink tools
#
PKG_TPM := "${@'packagegroup-security-tpm2' if 'meta-tpm' in d.getVar('BBLAYERS') else ''}"
PKG_SEMA := "${@'sema' if 'meta-adlink-sema' in d.getVar('BBLAYERS') else ''}"
SUMMARY:packagegroup-adlink-tools = "Adlink Tools Support"
RDEPENDS:packagegroup-adlink-tools = " \
    mraa \
    mraa-dev \
    mraa-doc \
    mraa-utils \
    upm \
    upm-dev \
    python3-upm \
    python3-mraa \
    ${PKG_SEMA} \
    ${PKG_TPM} \
"

RDEPENDS_GROUP_EXTRA_UTILS ?= ""


SUMMARY:packagegroup-adlink-utils = "Adlink Utils Support"
RDEPENDS:packagegroup-adlink-utils = " \
    alsa-utils \
    alsa-tools \
    bash \
    bzip2 \
    pbzip2 \
    coreutils \
    cmake \
    cpufrequtils \
    curl \
    dmidecode \
    dtc \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    evtest \
    fbset \
    fb-test \
    fbida \
    git \
    gzip \
    haveged \
    hdparm \
    htop \
    i2c-tools \
    ifupdown \
    imagemagick \
    libstdc++ \
    libgpiod \
    make \
    mbw \
    minicom \
    mmc-utils \
    parted \
    picocom \
    python3 \
    spitools \
    v4l-utils \
    usbutils \
    wget \
    ${@bb.utils.contains('PACKAGE_CLASSES', 'package_rpm', 'dnf', '', d)} \
    ${@bb.utils.contains('IMAGE_FEATURES', 'ssh-server-openssh', 'packagegroup-core-ssh-openssh openssh openssh-sftp-server', '', d)} \
    ${RDEPENDS_GROUP_EXTRA_UTILS} \
"

RDEPENDS_GROUP_EXTRA_NET ?= ""
RDEPENDS_GROUP_EXTRA_NET:sp2-imx8mp = " mdio-tools mdio-netlink"

#
# packages added by adlink basic network tools
#
SUMMARY:packagegroup-adlink-net = "Adlink basic network tools"
RDEPENDS:packagegroup-adlink-net = " \
    dnsmasq \
    can-utils \
    libsocketcan \
    inetutils \
    iperf3 \
    iptables \
    iproute2 \
    iproute2-tc \
    bridge-utils \
    net-tools \
    ethtool \
    ${RDEPENDS_GROUP_EXTRA_NET} \
"

#
# packages added by adlink continuous integration
#
SUMMARY:packagegroup-adlink-ci = "Adlink Continuous Integration Support"
RDEPENDS:packagegroup-adlink-ci = " \
    python3 \
    python3-robotframework \
"

#
# packages added by adlink debugging support
#
SUMMARY:packagegroup-adlink-debug = "Adlink Debugging Support"
RDEPENDS:packagegroup-adlink-debug = " \
    gdb \
    lsof \
    strace \
    tcpdump \
    phytool \
    binutils \
"


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

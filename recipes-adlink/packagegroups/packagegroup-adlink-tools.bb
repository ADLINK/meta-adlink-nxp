# Copyright 2021 ADLINK
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "ADLINK packagegroup for packacking tools for all ADLINK Distributions"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES = "packagegroup-adlink \
            packagegroup-adlink-sensors \
            packagegroup-adlink-benchmarks \
            packagegroup-adlink-wifi \
            packagegroup-adlink-bluetooth \
            packagegroup-adlink-tools \
            packagegroup-adlink-utils \
"

#
# packagegroup-adlink contain stuff needed for adlink build images
#
RDEPENDS_packagegroup-adlink = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'sensors', 'packagegroup-adlink-sensors', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'benchmarks', 'packagegroup-adlink-benchmarks', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'wifi', 'packagegroup-adlink-wifi', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'bluetooth', 'packagegroup-adlink-bluetooth', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'adlink', 'packagegroup-adlink-tools', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'adlink', 'packagegroup-adlink-utils', '', d)} \
"

#
# packages added by adlink sensors
#
SUMMARY_packagegroup-adlink-sensors = "Adlink Sensors Support"
RDEPENDS_packagegroup-adlink-sensors = " \
    lmsensors-fancontrol \
    lmsensors-libsensors \
    lmsensors-pwmconfig \
    lmsensors-sensord \
    lmsensors-sensors \
    lmsensors-sensorsconfconvert \
    lmsensors-sensorsdetect \
"

SUMMARY_packagegroup-adlink-benchmarks = "Adlink Benchmarks Support"
RDEPENDS_packagegroup-adlink-benchmarks = " \
    glmark2 \
    memtester \
    fio \
    iozone3 \
    lmbench \
    stress-ng \
    stressapptest \
    sysbench \
"

#
# packages added by adlink tools for wifi
#
SUMMARY_packagegroup-adlink-wifi = "Adlink wifi Support"
RDEPENDS_packagegroup-adlink-wifi = " \
    linux-firmware-sd8997 \
    kernel-module-sd8997 \
    nxp-wlan-sdk \
    iperf3 \
    iw \
    rfkill \
    connman \
    wireless-tools \
    wpa-supplicant \
    dhcp-server \
    dhcp-client \
"

#
# packages added by adlink tools for bluetooth
#
SUMMARY_packagegroup-adlink-bluetooth = "Adlink bluetooth Support"
RDEPENDS_packagegroup-adlink-bluetooth = " \
    linux-firmware-sd8997 \
    kernel-module-bt-sd8997 \
    nxp-bt-sdk \
    rfkill \
    bluez5 \
"

#
# packages added by adlink tools
#
SUMMARY_packagegroup-adlink-tools = "Adlink Tools Support"
RDEPENDS_packagegroup-adlink-tools = " \
    adlink-imx8mp-startup \
    sema \
    test-tools \
    powerled \
    mraa \
    mraa-dev \
    mraa-doc \
    mraa-utils \
    upm \
    upm-dev \
    python3-upm \
    python3-mraa \
"

SUMMARY_packagegroup-adlink-utils = "Adlink Utils Support"
RDEPENDS_packagegroup-adlink-utils = " \
    alsa-utils \
    alsa-tools \
    bash \
    bzip2 \
    pbzip2 \
    can-utils \
    coreutils \
    cryptoauthlib-3.2.4 \
    cryptoauthlib-3.2.4-dev \
    cmake \
    curl \
    dnf \
    dnsmasq \
    dtc \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    evtest \
    ethtool \
    fbset \
    fb-test \
    fbida \
    firmware-imx-sdma \
    gdb \
    git \
    gzip \
    hdparm \
    htop \
    i2c-tools \
    ifupdown \
    inetutils \
    imagemagick \
    iperf3 \
    iptables \
    iproute2 \
    libstdc++ \
    libgpiod \
    libsocketcan \
    make \
    minicom \
    mmc-utils \
    net-tools \
    openssh \
    openssh-sftp-server \
    parted \
    picocom \
    python \
    python3 \
    spitools \
    version \
    v4lcap-mplane \
    v4l-utils \
    wget \
    ${@bb.utils.contains('IMAGE_FEATURES', 'ssh-server-openssh', 'packagegroup-core-ssh-openssh', '', d)} \
"

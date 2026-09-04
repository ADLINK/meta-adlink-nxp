# Real-time Edge base conf for SP2-IMX8MP

#DISTRO = "nxp-real-time-edge"
DISTROOVERRIDES:append = ":real-time-edge"
#DISTRO_NAME = "NXP Real-time Edge Distro"
#DISTRO_VERSION = "3.1"

CONNECTIVITY_CHECK_URIS ?= "https://yoctoproject.org/connectivity.html"

DISTRO_FEATURES:append:mx8mp-nxp-bsp = " real-time-edge-sysrepo"
REAL_TIME_EDGE_SYSREPO:mx8mp-nxp-bsp = "real-time-edge-sysrepo-tc"
PACKAGECONFIG:append:pn-real-time-edge-sysrepo = "${REAL_TIME_EDGE_SYSREPO}"

# dtb for jailhouse
KERNEL_DEVICETREE:append:sp2-imx8mp = " freescale/imx8mp-evk-root.dtb \
					       freescale/imx8mp-evk-rpmsg-ca53.dtb \
					       freescale/imx8mp-evk-virtio-net-cm7.dtb \
					       freescale/imx8mp-evk-virtio-perf-cm7.dtb \
					       freescale/imx8mp-evk-virtio-net-ca53.dtb \
					       freescale/imx8mp-evk-virtio-perf-ca53.dtb \
					       freescale/imx8mp-evk-multicore-rtos.dtb \
					       freescale/imx8mp-evk-multicore-lwip.dtb \
					       freescale/imx8mp-evk-multicore-rpmsg.dtb \
					       freescale/imx8mp-evk-dsa.dtb \
					       freescale/imx8mp-evk-revb4-dsa.dtb \
					       freescale/imx8mp-evk-dsa-enetc.dtb \
					       freescale/imx8mp-evk-revb4-dsa-enetc.dtb \
					       freescale/imx8mp-evk-revb4-dsa-fec-swp0.dtb \
					       freescale/imx8mp-evk-revb4-dsa-fec-swp3.dtb "

# dtb for igh
KERNEL_DEVICETREE:append:sp2-imx8mp = " freescale/imx8mp-evk-igh.dtb"

# dtb for plc
KERNEL_DEVICETREE:append:sp2-imx8mp = " freescale/imx8mp-evk-ecat.dtb"

# dtb for EtherCAT userspace application
KERNEL_DEVICETREE:append:sp2-imx8mp = " freescale/imx8mp-evk-ecat-userspace.dtb"


# ethercat
IGH_ETHERCAT:sp2-imx8mp = " fec "
PACKAGECONFIG:append:pn-igh-ethercat = " ${IGH_ETHERCAT} "
IMAGE_INSTALL:append:real-time-edge = " igh-ethercat"

# libopen62541 (opc ua) override default log level
include ${BSPDIR}/sources/meta-real-time-edge/conf/distro/include/libopen62541.inc
LIBOPEN62541_LOGLEVE:real-time-edge = "300"
IMAGE_INSTALL:append:real-time-edge = " libopen62541"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/jailhouse/*.bbappend"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/tsntool/tsntool_%.bbappend"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/ethtool/ethtool_%.bbappend"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/linuxptp/linuxptp_3.1.bbappend"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/avahi/avahi_%.bbappend"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/iproute2/iproute2_%.bbappend"
BBMASK:append:real-time-edge = " meta-real-time-edge/recipes-extended/lldpd/lldpd_%.bbappend"

# real time edge utils
IMAGE_INSTALL:append:real-time-edge = " linuxptp jailhouse iproute2 lldpd avahi-daemon avahi-utils firmwared"


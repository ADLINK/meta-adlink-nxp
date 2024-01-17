#!/bin/sh

TOKEN_PRE="ghp_"
TOKEN_POST="DiFPUbMC2PjG06sFvpuDrsBdJAH5bO0bSQd9"
CWD=$(pwd)
DISTRO_NAME="$DISTRO"
MACHINE_NAME="$MACHINE"

if [ "$DISTRO" = "imx-desktop-xwayland" ]; then
	PROGNAME="$CWD/imx-setup-desktop.sh"
else
	PROGNAME="$CWD/imx-setup-release.sh"
fi

if [ -z "$BUILD" ]; then
	BUILD="build"
fi

MACHINE=$MACHINE DISTRO=$DISTRO BUILD_DIR=$BUILD source $PROGNAME $@

if [ -f ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.append ]; then
	cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.append >> ./conf/bblayers.conf
fi
if [ -f ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.append ]; then
	cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.append >> ./conf/local.conf
fi

echo "PA_USER ?= \"adlink-guest\"" >> ./conf/local.conf
echo "PA_TOKEN ?= \""${TOKEN_PRE}${TOKEN_POST}"\"" >> ./conf/local.conf

if [ ! "${DISTRO_NAME}" = "adlink-rtedge-desktop" ]; then
	echo "BBMASK += \"rteval_%.bbappend\"" >> ./conf/local.conf
fi

if [ -d ../sources/meta-nxp-desktop ]; then
	if ! grep -q meta-nxp-desktop ./conf/bblayers.conf; then
		echo "BBLAYERS += \"\${BSPDIR}/sources/meta-nxp-desktop\"" >> ./conf/bblayers.conf
	fi
	if [ "${DISTRO_NAME}" = "imx-desktop-xwayland" ]; then
		echo "RDEPENDS:qtbase:remove=\"vulkan-loader\"" >> ./conf/local.conf
		echo "RDEPENDS:qtbase:append=\" libvulkan-imx\"" >> ./conf/local.conf
	fi
else
	echo "BBMASK += \"imx-image-desktop.bbappend\"" >> ./conf/local.conf
	echo "BBMASK += \"ubuntu-base_%.bbappend\"" >> ./conf/local.conf
fi


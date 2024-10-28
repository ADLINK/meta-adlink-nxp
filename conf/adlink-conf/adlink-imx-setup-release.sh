#!/bin/sh

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

if [ -d ../sources/meta-adlink-demo ]; then
	if ! grep -q meta-adlink-demo ./conf/bblayers.conf; then
		echo "BBLAYERS += \"\${BSPDIR}/sources/meta-adlink-demo\"" >> ./conf/bblayers.conf
	fi
fi

if [ -d ../sources/meta-nxp-desktop ]; then
	if ! grep -q meta-nxp-desktop ./conf/bblayers.conf; then
		echo "BBLAYERS += \"\${BSPDIR}/sources/meta-nxp-desktop\"" >> ./conf/bblayers.conf
	fi
	if [ "${DISTRO_NAME}" = "imx-desktop-xwayland" ]; then
		cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/desktop.local.conf.append >> ./conf/local.conf
		echo "RDEPENDS:qtbase:remove=\"vulkan-loader\"" >> ./conf/local.conf
		echo "RDEPENDS:qtbase:append=\" libvulkan-imx\"" >> ./conf/local.conf
	fi
else
	echo "BBMASK += \"imx-image-desktop.bbappend\"" >> ./conf/local.conf
	echo "BBMASK += \"ubuntu-base_%.bbappend\"" >> ./conf/local.conf
fi

if [ "$MULTILIB" = "lib32" ]; then
	cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/multilib.local.conf.append >> ./conf/local.conf
fi

if [ ! "${DISTRO_NAME}" = "adlink-rtedge-desktop" ]; then
	echo "BBMASK += \"rteval_%.bbappend\"" >> ./conf/local.conf
fi

# nxp-wlan-sdk bbappend is not buildable, mask it
echo "BBMASK += \"nxp-wlan-sdk_%.bbappend\"" >> ./conf/local.conf

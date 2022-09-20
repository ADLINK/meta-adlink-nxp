#!/bin/sh

TOKEN_PRE="ghp_"
TOKEN_POST="DiFPUbMC2PjG06sFvpuDrsBdJAH5bO0bSQd9"

if [ -z "$BUILD" ]; then
	BUILD=build
fi

MACHINE=$MACHINE DISTRO=$DISTRO source imx-setup-release.sh -b $BUILD

if [ -f ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf ]; then
	cp ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf ./conf/
else
	cp ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.sample ./conf/bblayers.conf
fi
if [ -f ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf ]; then
	cp ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf ./conf/
else
	cp ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.sample ./conf/local.conf
fi

echo "PA_USER ?= \"adlink-guest\"" >> ./conf/local.conf
echo "PA_TOKEN ?= \""${TOKEN_PRE}${TOKEN_POST}"\"" >> ./conf/local.conf


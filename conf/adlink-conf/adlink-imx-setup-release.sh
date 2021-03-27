#!/bin/sh

if [ -z "$BUILD" ]; then
	BUILD=build
fi

MACHINE=$MACHINE DISTRO=$DISTRO source imx-setup-release.sh -b $BUILD

cp ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf ./conf/
cp ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf ./conf/

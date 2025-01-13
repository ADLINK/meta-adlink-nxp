#!/bin/bash
#
# Start the isp_media_server in the configuration for Framos IMX678
#
# (c) Framos 2024
# (c) NXP 2020-2021
#

RUNTIME_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NR_DEVICE_TREE_IMX678=$(grep imx678 `find /sys/firmware/devicetree/base/soc@0/ -name compatible | grep i2c` -l | wc -l 2> /dev/null)

# check for imx678 devices
if [ $NR_DEVICE_TREE_IMX678 -eq 2 ]; then

	echo "Starting isp_media_server for Dual IMX678"

	cd $RUNTIME_DIR
	
	exec ./run.sh -c dual_imx678_4k -lm
	
elif [ $NR_DEVICE_TREE_IMX678 -eq 1 ]; then

	echo "Starting isp_media_server for IMX678"

	cd $RUNTIME_DIR
	
	exec ./run.sh -c imx678_4k -lm

else
	# no device tree found exit with code no device or address
	echo "No device tree found for IMX678, check dtb file!" >&2
	exit 6
fi

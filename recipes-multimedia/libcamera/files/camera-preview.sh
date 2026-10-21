#!/bin/sh
export LIBCAMERA_LOG_LEVELS=*:ERROR
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
export LIBCAMERA_IPA_MODULE_PATH=/usr/lib/libcamera/ipa
export LIBCAMERA_NXP_NEO_CONFIG_FILE=/usr/share/libcamera/pipeline/nxp/neo/config.yaml
export LIBCAMERA_IPA_CONFIG_PATH=/usr/share/libcamera/ipa
export LIBCAMERA_PIPELINES_MATCH_LIST='nxp/neo,imx8-isi,uvc'
cam -l
gst-launch-1.0 libcamerasrc camera-name=/base/soc/bus@42000000/i2c@42530000/ov13855_mipi@36 ! video/x-raw, width=2112, height=1568, format=YUY2 ! queue ! waylandsink

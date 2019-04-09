DESCRIPTION = "ADLINK BSP Image with XFCE X Window"

LICENSE = "MIT"

IMAGE_FEATURES += " package-management ssh-server-dropbear hwcodecs"

inherit core-image

REQUIRED_DISTRO_FEATURES = "x11"

IMAGE_INSTALL += "packagegroup-core-x11 \
     	 	  packagegroup-xfce-base "
		  
export IMAGE_BASENAME = "adlink-xfce-nxp"

### XFCE Tools
IMAGE_INSTALL += " garcon epiphany sysprof xfce4-screenshooter ristretto xfce4-taskmanager xfce4-appfinder xfce-dusk-gtk3 xfceshutdown startupconfig"

## For additional tools/packages
IMAGE_INSTALL_append = " cmake make ethtool iproute2 gdb gdbserver i2c-tools pulseaudio canutils haveged"

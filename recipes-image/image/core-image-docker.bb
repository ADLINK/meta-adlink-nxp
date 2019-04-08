DESCRIPTION = "ADLINK BSP Image with XFCE with Docker Window"

LICENSE = "MIT"

IMAGE_FEATURES += " package-management ssh-server-dropbear hwcodecs"

inherit core-image

REQUIRED_DISTRO_FEATURES = "x11"

IMAGE_INSTALL += "packagegroup-core-x11 \
     	 	  packagegroup-xfce-base "
		  
### XFCE Tools
IMAGE_INSTALL_append = " garcon epiphany sysprof xfce4-screenshooter ristretto xfce4-taskmanager xfce4-appfinder xfce-dusk-gtk3 xfceshutdown "

## SEMA applications
#IMAGE_INSTALL_append = " sema semagui-desktop trolltech startupconfig"
                 

## Docker
IMAGE_INSTALL_append = " docker docker-contrib connman connman-client"

export IMAGE_BASENAME = "adlink-xfce-docker-nxp"

## For additional tools/packages
IMAGE_INSTALL_append = " cmake make ethtool iproute2 gdb gdbserver i2c-tools pulseaudio canutils haveged"


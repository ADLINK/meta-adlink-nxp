DESCRIPTION = "ADLINK BSP Image with XFCE X Window"

LICENSE = "MIT"

IMAGE_FEATURES += " package-management ssh-server-dropbear hwcodecs"

inherit core-image

REQUIRED_DISTRO_FEATURES = "x11"

IMAGE_INSTALL += "packagegroup-core-x11 \
     	 	  packagegroup-xfce-base "
		  
TOOLCHAIN_HOST_TASK_append = " nativesdk-intltool nativesdk-glib-2.0"
TOOLCHAIN_HOST_TASK_remove_task-populate-sdk-ext = " nativesdk-intltool nativesdk-glib-2.0"



export IMAGE_BASENAME = "adlink-xfce-nxp"


### XFCE Tools
IMAGE_INSTALL += " garcon epiphany sysprof xfce4-screenshooter ristretto xfce4-taskmanager xfce4-appfinder xfce-dusk-gtk3 xfceshutdown "

## SEMA applications
#IMAGE_INSTALL_append = " sema semagui-desktop trolltech startupconfig"

## For additional tools/packages
IMAGE_INSTALL_append = " cmake make ethtool iproute2 gdb gdbserver i2c-tools pulseaudio canutils haveged"

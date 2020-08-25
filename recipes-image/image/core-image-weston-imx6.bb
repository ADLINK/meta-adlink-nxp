DESCRIPTION = "ADLINK BSP Image with Wayland Weston"
LICENSE = "MIT"

require recipes-fsl/images/imx-image-multimedia.bb

## SEMA applications
IMAGE_INSTALL_append = " sema"


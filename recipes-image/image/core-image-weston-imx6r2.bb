DESCRIPTION = "ADLINK BSP Image with Wayland Weston"
LICENSE = "MIT"

require recipes-fsl/images/imx-image-multimedia.bb

#Additional Tools & Test Tools
IMAGE_INSTALL += "imx-test gcc"

WKS_FILE = "adlink-imx8-imxboot-acs.wks.in"

IMAGE_ROOTFS_EXTRA_SPACE = "0"
IMAGE_OVERHEAD_FACTOR = "1.0"

WIC_SRC_ROOTFS = "--source rootfs"

DEPENDS += "e2fsprogs-native dosfstools-native mtools-native parted-native gptfdisk-native"

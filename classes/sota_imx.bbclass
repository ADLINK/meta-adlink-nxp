# i.MX8/9 OSTree/SOTA machine configuration.
# Inherited from sota.bbclass as sota_${SOTA_MACHINE}.

# i.MX8/9 boots a raw arm64 Image and cannot boot without a device tree.
OSTREE_KERNEL ?= "Image"

OSTREE_BOOTLOADER ?= "u-boot"

OSTREE_DEPLOY_DEVICETREE = "1"
OSTREE_MULTI_DEVICETREE_SUPPORT = "1"

OSTREE_KERNEL_ARGS ?= "${OSTREE_KERNEL_ARGS_COMMON} console=ttyLP0,115200 earlycon panic=10"
OSTREE_KERNEL_ARGS:lec-imx8mm = "${OSTREE_KERNEL_ARGS_COMMON} console=ttymxc1,115200 earlycon=ec_imx6q,0x30890000,115200 panic=10"
OSTREE_KERNEL_ARGS:sp2-imx8mp = "${OSTREE_KERNEL_ARGS_COMMON} console=ttymxc1,115200 earlycon=ec_imx6q,0x30890000,115200 panic=10"

# Must be override-qualified: sota.bbclass sets WKS_FILE:sota, and an
# override-qualified value wins regardless of order.
WKS_FILE:sota = "ota-ostree.wks.in"

# U-Boot standard boot scans the boot partition for boot.scr.uimg, so the
# bootloader itself needs no change, set UBOOT_BOOT_SCRIPT to ostree.scr
# to boot ota-ostree
UBOOT_BOOT_SCRIPT:sota = "ostree.scr"

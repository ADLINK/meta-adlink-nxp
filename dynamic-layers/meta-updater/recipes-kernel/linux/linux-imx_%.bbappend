# INHERIT="sota": from sota.bbclass => INITRAMFS_IMAGE ?= "initramfs-ostree-image"
# cause kernel.bbclass to d.appendVarFlag('do_bundle_initramfs', 'depends', ' ${INITRAMFS_IMAGE}:do_image_complete')
# which causes circular dependencies when building linux-imx.
INITRAMFS_IMAGE:sota = ""

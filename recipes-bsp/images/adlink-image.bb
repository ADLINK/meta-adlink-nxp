require recipes-core/images/core-image-base.bb

IMAGE_FEATURES += "ssh-server-openssh"

# OSTree keeps the running deployment and its rollback target on the same
# filesystem, but wic sizes the rootfs partition for one. Reserve room for the
# second here: without it there is no space for an update and every
# "ostree admin upgrade" fails on the device.
IMAGE_ROOTFS_EXTRA_SPACE = "2097152"

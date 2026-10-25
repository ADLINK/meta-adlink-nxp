#
# This initramfs is an input to the main image's wic assembly
# since it's initramfs, no need to build wic or wic.md5sum
# empty EXTRA_USERS_PARAMS so it avoid build fail with usermod command
#
IMAGE_FSTYPES:sota = "${INITRAMFS_FSTYPES}"
IMAGE_FSTYPES:remove:sota = "wic wic.md5sum"
EXTRA_USERS_PARAMS:sota = ""


# KERNEL_TEST_TOOLS copied from packagegroup-imx-core-tools,
# packages specified from RDEPENDS moved to APTGET_EXTRA_PACKAGES
KERNEL_TEST_TOOLS = "kernel-tools-iio kernel-tools-pci spidev-test"
KERNEL_TEST_TOOLS:mx8m-nxp-bsp = "kernel-tools-iio kernel-tools-pci spidev-test kernel-tools-virtio"

# DRM_TOOLS, OPENCL_TOOLS, VULKAN_TOOLS, WAYLAND_TOOLS copied from packagegroup-fsl-tools-gpu-external
DRM_TOOLS = ""
DRM_TOOLS:imxdrm  = "kmscube"
OPENCL_TOOLS = "clblast"
OPENCL_TOOLS:mx7-nxp-bsp = ""
OPENCL_TOOLS:mx8mm-nxp-bsp = ""
VULKAN_TOOLS = ""
#VULKAN_TOOLS:mx8-nxp-bsp:imxgpu3d = "vulkan-loader vulkan-validationlayers vulkan-headers vkmark vulkan-tools gfxreconstruct"
VULKAN_TOOLS:mx8mm-nxp-bsp = ""
WAYLAND_TOOLS = "mesa-demos ${GLMARK2}"
# ${@bb.utils.contains("DISTRO_FEATURES", "x11", "gtkperf renderdoc", "", d)}
GLMARK2 = ""
GLMARK2:imxgpu3d = "glmark2"

#
# additional yocto packages
#
CORE_IMAGE_EXTRA_INSTALL = " \
	${KERNEL_TEST_TOOLS} \
	${DRM_TOOLS} \
	${OPENCL_TOOLS} \
	${VULKAN_TOOLS} \
	${WAYLAND_TOOLS} \
	msgpacker \
	mdio-tools \
	edid-decode \
	usb-hset \
	mdio-tool \
	mdio-tool-scripts \
	pwm-beeper \
	imx-test \
	linux-serial-test \
	eltt2 \
	libdrm \
	libdrm-kms \
	libdrm-drivers \
	libdrm-tests \
	uart-mode \
	bt-hciattach \
	usb-mux \
	lvds-sscg \
	strace \
	fuse-mac \
	ffmpeg \
"
IMAGE_INSTALL:append = " ${CORE_IMAGE_EXTRA_INSTALL}"

UBUNTU_PROVIDER = "${@bb.utils.contains_any('UBUNTU_TARGET_VERSION', '22.04.1 20.04.3 18.04.3 16.04.5', 'ubuntu-base', '', d)}"
PREFERRED_PROVIDER_virtual/dosfstools ?= "${UBUNTU_PROVIDER}"
PREFERRED_PROVIDER_virtual/e2fsprogs-mke2fs ?= "${UBUNTU_PROVIDER}"
PREFERRED_PROVIDER_virtual/e2fsprogs-resize2fs ?= "${UBUNTU_PROVIDER}"
PREFERRED_PROVIDER_virtual/iproute2 ?= "${UBUNTU_PROVIDER}"
PREFERRED_PROVIDER_virtual/libtirpc ?= "${UBUNTU_PROVIDER}"
PREFERRED_PROVIDER_virtual/mobile-broadband-provider-info ?= "${UBUNTU_PROVIDER}"
PREFERRED_PROVIDER_virtual/libgpiod-tools ?= "${UBUNTU_PROVIDER}"

IMX_GPU_VIV_VER = "${@bb.utils.contains_any('UBUNTU_TARGET_VERSION', '22.04.1 20.04.3 18.04.3 16.04.5', '6.4.3.p4.6d-aarch64', '6.4.3.p4.6-aarch64', d)}"
PREFERRED_VERSION_imx-gpu-viv = "${IMX_GPU_VIV_VER}"

ROOTFS_POSTPROCESS_COMMAND:append = " do_custom_dconf_gdm3;"
fakeroot do_custom_dconf_gdm3() {
	set -x
	if [ -x "${IMAGE_ROOTFS}/usr/share/gdm/generate-config" ]; then
		sed -e 's,as_gdm\ pkill,dconf\ update\nas_gdm\ pkill,g' -i ${IMAGE_ROOTFS}/usr/share/gdm/generate-config
	fi
	set +x
}

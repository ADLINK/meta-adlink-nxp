##############################################################################
# from ubuntu-base-image.inc (i.e. ubuntu-base recipes)
##############################################################################
# NOTE: We cannot install arbitrary Yocto packages as they will conflict with
# the content of the prebuilt Ubuntu Desktop rootfs which pulls in dependencies
# that may break the rootfs.
# Additional yocto packages need to tweak following variablse,
# YOCTO-DEPENDS-LIST, APTGET_EXTRA_PACKAGES, and APTGET_EXTRA_PACKAGES_REMOVE
##############################################################################

#
# Extra yocto packages that NXP Desktop packages may conflict with
#
# RCONFLICTS:${PN} += "${YOCTO-DEPENDS-LIST}"
# RREPLACES:${PN} += "${YOCTO-DEPENDS-LIST}"
# RPROVIDES:${PN} += "${YOCTO-DEPENDS-LIST}"
#
YOCTO-DEPENDS-LIST:remove = " \
	libdrm-dev \
	libdrm-radeon \
	libdrm-nouveau \
	libdrm-omap \
	libdrm-intel \
	libdrm-exynos \
	libdrm-freedreno \
	libdrm-amdgpu \
	libdrm-etnaviv \
	libdrm-common \
	fontconfig \
	libvulkan1 \
	libvulkan-dev \
"

#
# apt-get packages pulled from ubuntu APT repo
#
APTGET_EXTRA_PACKAGES:append = " \
	usbutils \
	spi-tools \
	i2c-tools \
	dosfstools \
	evtest \
	e2fsprogs \
	fbset \
	iproute2 \
	libgpiod2 \
	gpiod \
	memtester \
	python3 \
	ethtool \
	mtd-utils \
	procps \
	ptpd \
	linuxptp \
	iw \
	can-utils \
	cpufrequtils \
	nano \
	ntpdate \
	minicom \
	coreutils \
	mmc-utils \
	udev \
	pciutils \
	hdparm \
	htop \
	mbw \
	stress-ng \
	alsa-utils \
	tpm2-tools \
	putty \
	gtkterm \
	f3 \
	fancontrol \
	lm-sensors \
	modemmanager \
	iperf \
	iperf3 \
	python3-msgpack \
	python3-smbus2 \
	python3-evdev \
	fio \
	gfio \
	wireless-regdb \
	yad \
"
# x11-xserver-utils

#
# apt-get packages to be removed for resolving conflict between apt-get install and yocto image install
#
# from nativeapiinstall.bbclass
# if [ -n "${APTGET_EXTRA_PACKAGES_REMOVE}" ]; then
#   chroot "${APTGET_CHROOT_DIR}" /usr/bin/dpkg --force-all -P ${APTGET_EXTRA_PACKAGES_REMOVE}
# fi
#
APTGET_EXTRA_PACKAGES_REMOVE += " \
	libdrm2 \
	libdrm-common \
	libdrm-tests \
	libdrm-dev \
	libdrm-kms \
	libdrm-etnaviv1 \
	libdrm-amdgpu1 \
	tracker \
	tracker-extract \
	tracker-miner-fs \
	fontconfig \
	libvulkan1 \
	libvulkan-dev \
"
# libdrm-nouveau2 libdrm-radeon1 libdrm-tegra0


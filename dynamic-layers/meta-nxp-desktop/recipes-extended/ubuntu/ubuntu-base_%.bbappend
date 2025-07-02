##############################################################################
# from ubuntu-base-image.inc (i.e. ubuntu-base recipes)
##############################################################################
# NOTE: We cannot install arbitrary Yocto packages as they will conflict with
# the content of the prebuilt Ubuntu Desktop rootfs which pulls in dependencies
# that may break the rootfs.
# Additional yocto packages need to tweak following variablse,
# YOCTO-DEPENDS-LIST, APTGET_EXTRA_PACKAGES, and APTGET_EXTRA_PACKAGES_REMOVE
#
# NOTE:
# to downgrade apt-get packages, download first and dpkg -i --force-all
# during install pkg_postinst_ontarget, but rpm package cannot do
# pkg_postinst_ontarget, so use systemd startup script instead
##############################################################################

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

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

APTGET_EXTRA_BINARY_PACKAGES = "libjavascriptcoregtk-4.0-18=2.36.0-2ubuntu1 libwebkit2gtk-4.0-37=2.36.0-2ubuntu1"

# apt-get install --allow-downgrades to install launchpad specific deb packages
fakeroot do_aptget_user_update:sp2-imx8mp() {
	set -x
	aptgetfailure=0
	echo  >"${APTGET_CHROOT_DIR}/aptgetpkg.sh" "#!/bin/sh"
	echo >>"${APTGET_CHROOT_DIR}/aptgetpkg.sh" "cd \$1"
	echo >>"${APTGET_CHROOT_DIR}/aptgetpkg.sh" "${APTGET_EXECUTABLE} ${APTGET_DEFAULT_OPTS} download \$2"
	x="${APTGET_EXTRA_BINARY_PACKAGES}"
	for i in $x; do
		test $aptgetfailure -ne 0 || chroot "${APTGET_CHROOT_DIR}" /bin/bash /aptgetpkg.sh "/root" "${i}" || aptgetfailure=1
	done
	rm -f "${APTGET_CHROOT_DIR}/aptgetpkg.sh"
	set +x
}

#UBUNTU_BASE_POSTINST_ONTARGET_COMMANDS ?= " \
#  for deb in `ls /root/*.deb`; do /usr/bin/dpkg -i --force-all $deb && rm -f $deb; done; \
#"
#
#pkg_postinst_ontarget:${PN} () {
#        ${UBUNTU_BASE_POSTINST_ONTARGET_COMMANDS}
#}

SRC_URI += "\
    file://ubuntu-base.service \
    file://ubuntu-base-startup \
"

inherit systemd

SYSTEMD_PACKAGES += "${PN}"
SYSTEMD_SERVICE:${PN} = "ubuntu-base.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install_startup() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d "${D}${sbindir}"
		install -m 0755 ${WORKDIR}/ubuntu-base-startup ${D}${sbindir}/ubuntu-base-startup
		install -d "${D}${systemd_unitdir}/system"
		install -m 0644 "${WORKDIR}/ubuntu-base.service" "${D}${systemd_unitdir}/system/ubuntu-base.service"
	fi
}
addtask install_startup before do_package after do_install

FILES:${PN} += "${sbindir} ${systemd_unitdir}/system"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "u-boot boot.scr.uimg"
DESCRIPTION = "Boot script for launching bootable disk images"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://README;md5=607f518505177f5b9f0d7e127cf1e8e1"

DEPENDS = "u-boot-mkimage-native"

PR = "r0"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

UBOOT_BOOT_SCRIPT ?= "boot.scr"

SRC_URI = "file://README \
file://boot.scr \
file://overlay.scr \
"

S = "${WORKDIR}"

do_compile () {
	for script in ${S}/*.scr; do
		mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
			-n "boot script" -d ${script} \
			${script}.uimg
	done
}

do_install () {
	install -d ${DEPLOY_DIR_IMAGE}
	install -m 0644 ${S}/*.uimg ${DEPLOY_DIR_IMAGE}
}


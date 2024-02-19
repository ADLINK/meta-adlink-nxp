SUMMARY = "custom dconf setting to modify default configurations"
DESCRIPTION = "Configuration files to modify default dconf setting for user"
SECTION = "app"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://adlink-l.jpg \
    file://adlink-d.jpg \
    file://profile-user \
    file://01-background \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# background image
	install -d ${D}${datadir}/backgrounds
	install -m 0644 ${S}/adlink-l.jpg ${D}${datadir}/backgrounds/adlink-l.jpg
	install -m 0644 ${S}/adlink-d.jpg ${D}${datadir}/backgrounds/adlink-d.jpg
	# custom dconf profile user to specify local to find keyfile
	install -d ${D}${sysconfdir}/dconf/profile
	install -m 0644 ${S}/profile-user ${D}${sysconfdir}/dconf/profile/user
	# custom dconf db keyfile to be dconf update
	install -d ${D}${sysconfdir}/dconf/db/local.d
	install -m 0644 ${S}/01-background ${D}${sysconfdir}/dconf/db/local.d/01-background
	#
	# NOTE: need to add "dconf update" after "dconf compile" in /usr/share/gdm/generate-config
	#       generate-config is called from gdm.service before gdm starts.
	# for imx-image-desktop: need to modify generate-config from image recipe
	# for other yocto image: need to modify generate-config from gdm recipe
	#
	#if [ -x ${D}${datadir}/gdm/generate-config ]; then
	#	sed -e 's,as_gdm\ pkill,dconf\ update\nas_gdm pkill,g' -i ${D}${datadir}/gdm/generate-config
	#fi
}

FILES:${PN} += "${sysconfdir}/dconf/ ${datadir}/backgrounds/"


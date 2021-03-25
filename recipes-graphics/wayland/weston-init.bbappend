SUMMARY= "ADLINK weston.ini file for Weston Wayland compositor"
DESCRIPTION= "Replace ADLINK weston.ini file to get ADLINK wallpaper on desktop \
              weston-adlink-imx6.ini - Uses ADLINK wallpaper and render using g2D \
              weston-adlink-imx8m.ini - Uses ADLINK wallpaper"
LICENSE= "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx6-1 += "file://weston-adlink-imx6.ini"
SRC_URI_append_lec-imx6-2 += "file://weston-adlink-imx6.ini"
SRC_URI_append_mx8mq += "file://weston-adlink-imx8m.ini"

do_install_append() {

if ${@bb.utils.contains('TARGET_ARCH', 'arm', 'true', 'false', d)}; then # LEC-i.MX6
   install ${WORKDIR}/weston-adlink-imx6.ini ${D}${sysconfdir}/xdg/weston/weston.ini

elif ${@bb.utils.contains('MACHINE', 'lec-imx8mp', 'true', 'false', d)}; then # LEC-i.MX8mp
   echo "skipping this for now"

elif ${@bb.utils.contains('TARGET_ARCH', 'aarch64', 'true', 'false', d)}; then # LEC-i.MX8m
   install ${WORKDIR}/weston-adlink-imx8m.ini ${D}${sysconfdir}/xdg/weston/weston.ini
fi

}

FILES_${PN} += "${sysconfdir}/xdg/weston/weston.ini"

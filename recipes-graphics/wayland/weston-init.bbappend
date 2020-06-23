SUMMARY= "ADLINK weston.ini file for Weston Wayland compositor"
DESCRIPTION= "Replace ADLINK weston.ini file to get ADLINK wallpaper on desktop"
LICENSE= "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_mx8mq += "file://weston-adlink.ini"

do_install_append() {

   install ${WORKDIR}/weston-adlink.ini ${D}${sysconfdir}/xdg/weston/weston.ini
}

FILES_${PN} += "${sysconfdir}/xdg/weston/weston.ini"

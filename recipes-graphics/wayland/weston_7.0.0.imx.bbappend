SUMMARY= "Weston, a Wayland compositor"
DESCRIPTION= "Include ADLINK wallpaper .jpg image to replace weston desktop wallpaper"
LICENSE= "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://adlink.jpg"

do_install_append() {

   install ${WORKDIR}/adlink.jpg ${D}${datadir}/weston
}

FILES_${PN} += "${datadir/weston}"

SUMMARY= "Weston, a Wayland compositor, i.MX fork"
DESCRIPTION= "Apply ADLINK wallpaper to weston desktop"
LICENSE= "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_mx8mq += " file://adlink.jpg \
                          file://0001-Add-ADLINK-Wallpaper-to-Weston-Desktop.patch \
                        "

do_install_append() {

   install ${WORKDIR}/adlink.jpg ${D}${datadir}/icons/hicolor/48x48/apps
}

FILES_${PN} += "${datadir}/icons/hicolor/48x48/apps"

LICENSE = "CLOSED"


## /usr/lib/SEMA/
##FILES_${PN} += "${libdir}/SEMA/"

# shutdown for xfce4
SRC_URI="file://shutdown.desktop"


S = "${WORKDIR}"

# Tasks
do_install() {
        # SEMA 3.5
    
        install -d -m 0755 ${D}/usr/share/applications

        cp -a ${WORKDIR}/shutdown.desktop ${D}/usr/share/applications
       
}

##FILES_${PN} += "/usr/local/ /etc/SEMA/"

do_package_qa() {
}

#INSANE_SKIP_${PN} = "already-stripped dev-so"
INSANE_SKIP_${PN} = "already-stripped"

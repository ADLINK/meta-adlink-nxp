SUMMARY = "The eiq examples based on Tf-lite"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


SRC_URI:append = " file://download_models_final.py "


S = "${WORKDIR}/git"

do_install:append:osm-imx93 () {

    cp ${S}/../download_models_final.py ${D}${bindir}/${PN}-${PV}/

}


SUMMARY = "RAUC setup on boot"
LICENSE = "MIT"
SRC_URI = "file://adlinkrauc.sh \
           file://adlinkrauc.service \
           file://keyring.pem \
           file://system_emmc.conf \
           file://system_sd.conf"
LIC_FILES_CHKSUM = "file://adlinkrauc.sh;md5=1a1f99dea4f6b990875a2fcf08398387"


S = "${WORKDIR}"

do_install () {
    # Install systemd service
    install -d ${D}${systemd_unitdir}/system/
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    install -m 0644 ${S}/adlinkrauc.service ${D}${systemd_unitdir}/system/
    ln -sf ../../../../${systemd_unitdir}/system/adlinkrauc.service \
           ${D}${sysconfdir}/systemd/system/multi-user.target.wants/adlinkrauc.service

    # Install shell script
    install -d ${D}${bindir}/
    install -m 0755 ${S}/adlinkrauc.sh ${D}${bindir}/
    # install rauc sysconf and keyring
    install -d ${D}${sysconfdir}/rauc/
    install -m 0644 ${S}/keyring.pem ${D}${sysconfdir}/rauc/
    install -m 0644 ${S}/system_emmc.conf ${D}${sysconfdir}/rauc/
    install -m 0644 ${S}/system_sd.conf ${D}${sysconfdir}/rauc/
}

FILES:${PN} += "${bindir} ${systemd_unitdir}/system ${sysconfdir}/systemd/system"
RDEPENDS:${PN} += "bash coreutils"


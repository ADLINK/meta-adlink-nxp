SUMMARY = "Confirm a successful OSTree boot to U-Boot's rollback counter"
DESCRIPTION = "Installs /etc/fw_env.config plus a oneshot service that clears \
U-Boot's bootcount and upgrade_available once the system reaches \
multi-user.target, and promotes the rollback deployment if U-Boot booted it."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://fw_env.config \
    file://ostree-boot-success.sh \
    file://ostree-boot-success.service \
"

S = "${UNPACKDIR}"

# fw_env.config hardcodes this board's environment offset.
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "ostree-boot-success.service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN} = "libubootenv-bin ostree u-boot-imx-env"

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/fw_env.config ${D}${sysconfdir}/fw_env.config

    # libubootenv falls back to /etc/u-boot-initial-env when the saved
    # environment is invalid, as it is on a freshly flashed card. u-boot-imx-env
    # ships that file under a PN-prefixed name.
    ln -sf u-boot-imx-initial-env ${D}${sysconfdir}/u-boot-initial-env

    install -d ${D}${bindir}
    install -m 0755 ${S}/ostree-boot-success.sh ${D}${bindir}/ostree-boot-success

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/ostree-boot-success.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${systemd_system_unitdir}"

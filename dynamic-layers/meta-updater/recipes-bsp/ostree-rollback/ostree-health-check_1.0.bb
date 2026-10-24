SUMMARY = "Application health check consulted by ostree-boot-success"
DESCRIPTION = "Installs /usr/bin/ostree-health-check. Set HEALTH_CHECK_RESULT \
to \"fail\" to build a deliberately broken image, so U-Boot's boot counter \
runs out and the board rolls back on its own."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# "pass" = healthy deployment, "fail" = simulated bad update
HEALTH_CHECK_RESULT ?= "pass"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${bindir}
    if [ "${HEALTH_CHECK_RESULT}" = "fail" ]; then
        cat > ${D}${bindir}/ostree-health-check <<'EOS'
#!/bin/sh
echo "health check: DELIBERATELY FAILING (simulated bad update)"
exit 1
EOS
    else
        cat > ${D}${bindir}/ostree-health-check <<'EOS'
#!/bin/sh
echo "health check: OK"
exit 0
EOS
    fi
    chmod 0755 ${D}${bindir}/ostree-health-check
}

# Without this, flipping HEALTH_CHECK_RESULT would not change the task hash
# and BitBake would reuse the cached result.
do_install[vardeps] += "HEALTH_CHECK_RESULT"

FILES:${PN} = "${bindir}/ostree-health-check"

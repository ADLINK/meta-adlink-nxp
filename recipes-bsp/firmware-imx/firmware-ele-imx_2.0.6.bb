# Copyright 2021-2025 NXP
#
# NXP ELE firmware 2.0.6 (LF6.18.20_2.0.0), built on scarthgap.
# Only for osm-imx95, which selects it with PREFERRED_VERSION_firmware-ele-imx = "2.0.6"

SUMMARY = "NXP i.MX ELE firmware"
DESCRIPTION = "EdgeLock Secure Enclave firmware for i.MX series SoCs"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=bc649096ad3928ec06a8713b8d787eac"

inherit fsl-eula-unpack use-imx-security-controller-firmware deploy

SRC_URI = "${FSL_MIRROR}/${BP}-${IMX_SRCREV_ABBREV}.bin;fsl-eula=true"
IMX_SRCREV_ABBREV = "c0b284c"
SRC_URI[sha256sum] = "ff42b838c42448616d3f6dc5a7f0d47c207bb0bae1ae00bea091103ed4012c28"

S = "${WORKDIR}/${BP}-${IMX_SRCREV_ABBREV}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/imx/ele
    for fw in ${SECO_FIRMWARE_NAME} ${SECOEXT_FIRMWARE_NAME}; do
        install -m 0644 ${S}/$fw ${D}${nonarch_base_libdir}/firmware/imx/ele
    done
}

do_deploy () {
    # Deploy the related firmware to be packaged by imx-boot
    for fw in ${SECO_FIRMWARE_NAME}; do
        install -m 0644 ${S}/$fw  ${DEPLOYDIR}
    done
}
addtask deploy after do_install before do_build

FILES:${PN} = "${nonarch_base_libdir}/firmware"

RREPLACES:${PN} = "firmware-sentinel"
RPROVIDES:${PN} = "firmware-sentinel"

# Only osm-imx95: this layer has a higher priority than meta-imx, so every
# other i.MX95 machine (e.g. lec-imx95) would pick this recipe too.
# DEFAULT_PREFERENCE cannot prevent that across layers.
COMPATIBLE_MACHINE = "(osm-imx95)"

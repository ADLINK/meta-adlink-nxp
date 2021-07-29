FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

UBOOT_SRC_PATCHES[lec-imx8mp] = " \
  file://adlink_lec8mp_defconfig \
  file://lec-imx8mp.dts \
  file://0001-board-add-lec-imx8mp-source.patch \
  file://0002-u-boot-modify-Kconfig-Makefile-to-build-lec-imx8mp.patch \
"

UBOOT_SRC_private = "git://github.com/ADLINK/u-boot-adlink.git;protocol=https"
SRCBRANCH_private = "lf_v2021.04-adlink"
SRC_URI_private = "${UBOOT_SRC};branch=${SRCBRANCH};user=${PRIVATE_USER}:${PRIVATE_TOKEN};"
SRCREV_private = "5f9689b0fd44532af6f4f9aad1cf1ba2d2d0a45e"

SRC_URI += "${@bb.utils.contains_any('MACHINE', 'lec-imx8m lec-imx8mp', d.getVarFlag('UBOOT_SRC_PATCHES', d.getVar('MACHINE'), True), '', d) if 'private' not in d.getVar('OVERRIDES') else ''}"

do_copy_source () {
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
  dtbes=$(echo "${UBOOT_DTB_NAME}" | xargs)
  bbnote "u-boot dtbes: $dtbes"

  # Copy config and dts
  for config in ${configs}; do
    if [ -f ${WORKDIR}/${config} ]; then
      bbnote "u-boot config: $config"
      cp -f ${WORKDIR}/${config} ${S}/configs/
    fi
  done
  for dtbname in ${dtbes}; do
    dtsname=$(echo "${dtbname%%.*}.dts")
    if [ -f ${WORKDIR}/$dtsname ]; then
      bbnote "u-boot dts: ${dtsname}"
      cp -f ${WORKDIR}/$dtsname ${S}/arch/arm/dts/
    fi
  done
}

addtask copy_source before do_patch after do_unpack

do_configure_prepend () {

  # Additional CONFIG_XXX for u-boot config
  # E.g. in local.conf
  #     UBOOT_EXTRA_CONFIGS = "LPDDR4_8GB"
  #
  # For imx8mq:
  #     DDR3L_1GB, DDR3L_2GB, DDR3L_4GB, DDR3L_4GB_MT
  # For imx8mp:
  #     LPDDR4_2GB, LPDDR4_2GK, LPDDR4_4GB, LPDDR4_8GB
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
  extras=$(echo "${UBOOT_EXTRA_CONFIGS}" | xargs)
  echo "Add ${extras} to ${configs}"
  for extra in ${extras}; do
    if [ -n $extra ]; then
      for config in $configs; do
        if [ -f ${S}/configs/${config} ]; then
          upper=$(echo ${extra} | tr '[:lower:]' '[:upper:]')
          echo "CONFIG_${upper##CONFIG_}=y" | tee -a ${S}/configs/${config}
        fi
      done
    fi
  done
}

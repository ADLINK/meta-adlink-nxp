FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_lec-imx8mp = " \
  file://adlink_lec8mp_defconfig \
  file://lec-imx8mp.dts \
  file://0001-board-add-lec-imx8mp-source.patch \
  file://0002-u-boot-modify-Kconfig-Makefile-to-build-lec-imx8mp.patch \
"

SRC_URI_append_lec-imx8m = " \
  file://adlink_lec8m_defconfig \
  file://lec-imx8m.dts \
  file://0001-board-add-lec-imx8mq-source.patch \
  file://0002-imx8mq-Fix-QL-CPU-with-no-HDMI-output-issue.patch \
  file://0003-Kconfig-modify-to-include-lec-imx8mq-build.patch \
"

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

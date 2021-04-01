FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_configure_prepend () {
  # Additional CONFIG_XXX for u-boot build
  # E.g. in local.conf
  #     UBOOT_EXTRA_CONFIGS = "LPDDR4_8GB"
  #
  # For imx8mq:
  #     DDR3L_1GB, DDR3L_2GB, DDR3L_4GB, DDR3L_4GB_MT
  # For imx8mp:
  #     LPDDR4_2GB, LPDDR4_2GK, LPDDR4_4GB, LPDDR4_8GB
  extras=$(echo "${UBOOT_EXTRA_CONFIGS}" | xargs)
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
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

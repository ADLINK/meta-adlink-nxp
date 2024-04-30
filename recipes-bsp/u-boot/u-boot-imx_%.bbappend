FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SPLASH_IMAGE ?= "splash.bmp"
UBOOT_UMS_IMAGE ?= "ums.bmp"
EXTRA_SRC = "${@d.getVarFlag('UBOOT_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

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
      if [ -f ${S}/arch/arm/dts/Makefile ]; then
        if ! grep -q $dtbname ${S}/arch/arm/dts/Makefile; then
          bbnote "Makefile: add ${dtbname}"
          sed -e 's,dtb-$(CONFIG_ARCH_IMX8M) += \\,dtb-$(CONFIG_ARCH_IMX8M) += \\\n\t'${dtbname}' \\,g' -i ${S}/arch/arm/dts/Makefile
        fi
      fi
    fi
  done
}

addtask copy_source before do_patch after do_unpack

do_configure:prepend () {

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
  bbnote "Add ${extras} to ${configs}"
  for extra in ${extras}; do
    if [ -n $extra ]; then
      for config in $configs; do
        if [ -f ${S}/configs/${config} ]; then
          case "${extra}" in
          NO_*)
            upper=$(echo ${extra#NO_} | tr '[:lower:]' '[:upper:]')
            echo "CONFIG_${upper##CONFIG_}=n" | tee -a ${S}/configs/${config}
            ;;
          *)
            upper=$(echo ${extra} | tr '[:lower:]' '[:upper:]')
            echo "CONFIG_${upper##CONFIG_}=y" | tee -a ${S}/configs/${config}
            ;;
          esac
        fi
      done
    fi
  done
}

do_install:append () {
	install -d ${DEPLOY_DIR_IMAGE}
	if [ -f ${WORKDIR}/${UBOOT_SPLASH_IMAGE} ]; then
		install -m 0644 ${WORKDIR}/${UBOOT_SPLASH_IMAGE} ${DEPLOY_DIR_IMAGE}/${UBOOT_SPLASH_IMAGE}
	else
		bbwarn "${S}/${UBOOT_SPLASH_IMAGE} not found. No splash image for u-boot"
	fi
	if [ -f ${WORKDIR}/${UBOOT_UMS_IMAGE} ]; then
		install -m 0644 ${WORKDIR}/${UBOOT_UMS_IMAGE} ${DEPLOY_DIR_IMAGE}/${UBOOT_UMS_IMAGE}
	else
		bbwarn "${S}/${UBOOT_UMS_IMAGE} not found. No ums image for u-boot"
	fi
}


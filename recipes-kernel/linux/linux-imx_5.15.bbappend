FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


EXTRA_SRC = "${@d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
  configs=$(echo "${IMX_KERNEL_CONFIG_AARCH64}" | xargs)
  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)

  # Copy config
  if [ -n "${configs}" ]; then
    for config in ${configs}; do
      if [ -f ${WORKDIR}/${config} -a ! -f ${S}/arch/arm64/configs/${IMX_KERNEL_CONFIG_AARCH64} ]; then
        bbnote "copy kernel config: $config"
        cp -f ${WORKDIR}/${config} ${S}/arch/arm64/configs/${config}
      fi
    done
  fi

  # Copy device trees
  if [ -n "${dtbes}" ]; then
    for dtbname in ${dtbes}; do
      dtsname=$(echo "${dtbname%%.*}.dts")
      dtsfile=$(basename -- $dtsname)
      if [ -f ${WORKDIR}/$dtsfile ]; then
        if [ ! -d ${S}/arch/arm64/boot/dts/adlink ]; then
          mkdir -p ${S}/arch/arm64/boot/dts/adlink/
        fi
        bbnote "copy kernel dts: $dtsfile"
        cp -f ${WORKDIR}/$dtsfile ${S}/arch/arm64/boot/dts/adlink/
      fi
    done
  fi
    if [ ${MACHINE} = "lec-imx8mp" ]; then
     cp -f ${WORKDIR}/tlv320aic3x.dtsi ${S}/arch/arm64/boot/dts/adlink/
   fi  
  
}

addtask copy_source before do_validate_branches after do_kernel_checkout

RDEPENDS_${PN} += "kernel-devsrc"

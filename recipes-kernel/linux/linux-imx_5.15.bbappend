FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#LOCALVERSION_private = "-lts-5.10.y-adlink"
#SRCBRANCH_private = "lf-5.10.y-adlink"
#KERNEL_SRC_private = "git://github.com/ADLINK/linux-adlink.git;protocol=https"
#SRC_URI_private = "${KERNEL_SRC};branch=${SRCBRANCH};user=${PRIVATE_USER}:${PRIVATE_TOKEN};"
#SRCREV_private = "925f549eadf84f591d0233357c8adfaa52f9d480"

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
}

addtask copy_source before do_validate_branches after do_kernel_checkout

RDEPENDS_${PN} += "kernel-devsrc"

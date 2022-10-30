FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRCBRANCH_private = "lf_v2021.04-adlink-lec8mm"
UBOOT_SRC_private = "git://github.com/ADLINK/u-boot-adlink.git;protocol=https"
SRC_URI_private = "${UBOOT_SRC};branch=${SRCBRANCH};user=${PRIVATE_USER}:${PRIVATE_TOKEN};"
SRCREV_private = "e9400351071a4533dbefa780d89c49129620cbfc"

EXTRA_SRC = "${@d.getVarFlag('UBOOT_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI_append = " ${EXTRA_SRC}"

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



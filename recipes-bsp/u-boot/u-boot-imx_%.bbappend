FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


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
    fi
  done
}

addtask copy_source before do_patch after do_unpack



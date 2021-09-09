FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KERNEL_SRC_PATCHES[lec-imx8mp] = " \
	file://lec-imx8mp_defconfig \
	file://0001-LEC-IMX8MP-Port-LEC-iMX8MP-platfrom-base-on-i.MX8MP.patch \
	file://0002-DTB-modify-Makefile-to-build-lec-imx8mp-dtbs.patch \
	file://lec-imx8mp-auoB101UAN01-mipi-panel.dts \
	file://lec-imx8mp-hydis-hv150ux2.dts \
	file://lec-imx8mp.dts \
"

EXTRA_DEVICETREE_wifibt = " file://lec-imx8mp-wifi.dts"
KERNEL_SRC_PATCHES[lec-imx8mp] += " ${EXTRA_DEVICETREE}"

SRCBRANCH_private = "lf-5.10.y-adlink"
LOCALVERSION_private = "-lts-5.10.y-adlink"
KERNEL_SRC_private = "git://github.com/ADLINK/linux-adlink.git;protocol=https"
SRC_URI_private = "${KERNEL_SRC};branch=${SRCBRANCH};user=${PRIVATE_USER}:${PRIVATE_TOKEN};"
SRCREV_private = "925f549eadf84f591d0233357c8adfaa52f9d480"

SRC_URI += "${@bb.utils.contains_any('MACHINE', 'lec-imx8m lec-imx8mp', d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True), '', d) if 'private' not in d.getVar('OVERRIDES') else ''}"

SRC_URI_append_tinycma = " \
			file://0001-dtb-reduce-cma-size-for-adlink-imx8mp-som.patch \
"

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

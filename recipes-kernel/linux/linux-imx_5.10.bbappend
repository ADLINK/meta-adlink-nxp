FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://lec-imx8mp_defconfig \
	file://0001-LEC-IMX8MP-Port-LEC-iMX8MP-platfrom-base-on-i.MX8MP.patch \
	file://0002-DTB-modify-Makefile-to-build-lec-imx8mp-dtbs.patch \
	file://lec-imx8mp-auoB101UAN01-mipi-panel.dts \
	file://lec-imx8mp-hydis-hv150ux2.dts \
	file://lec-imx8mp.dts \
	file://lec-imx8mp-wifi.dts \
	file://linux-tc.config \
"

SRC_URI_append_tinycma = " \
			file://0001-dtb-reduce-cma-size-for-adlink-imx8mp-som.patch \
"

do_copy_source () {
  configs=$(echo "${IMX_KERNEL_CONFIG_AARCH64}" | xargs)
  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)

  # Copy config
  for config in ${configs}; do
    if [ -f ${WORKDIR}/${config} -a ! -f ${S}/arch/arm64/configs/${IMX_KERNEL_CONFIG_AARCH64} ]; then
      bbnote "copy kernel config: $config"
      cp -f ${WORKDIR}/${config} ${S}/arch/arm64/configs/${config}
    fi
  done

  # Copy device trees
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
}

addtask copy_source before do_validate_branches after do_kernel_checkout

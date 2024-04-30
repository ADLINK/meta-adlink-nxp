FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


EXTRA_SRC = "${@d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
  configs=$(echo "${IMX_KERNEL_CONFIG_AARCH64}" | xargs)
  deltaconfigs=$(echo "${DELTA_KERNEL_DEFCONFIG}" | xargs)
  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)
  extras=$(echo "${EXTRA_SRC}" | xargs)

  # Copy config
  if [ -n "${configs}" ]; then
    for config in ${configs}; do
      if [ -f ${WORKDIR}/${config} -a ! -f ${S}/arch/arm64/configs/${config} ]; then
        bbnote "copy kernel config: $config"
        cp -f ${WORKDIR}/${config} ${S}/arch/arm64/configs/${config}
      fi
    done
  fi

  if [ -n "${deltaconfigs}" ]; then
    for deltacfg in ${deltaconfigs}; do
      if [ -f ${WORKDIR}/${deltacfg} -a ! -f ${S}/arch/${ARCH}/configs/${deltacfg} ]; then
        bbnote "copy kernel delta config: $deltacfg"
        cp -f ${WORKDIR}/${deltacfg} ${S}/arch/arm64/configs/${deltacfg}
      fi
    done
  fi

  # copy dts and dtsi
  if [ -n "${extras}" -a -n "${dtbes}" ]; then
    if [ ! -d ${S}/arch/arm64/boot/dts/adlink ]; then
      mkdir -p ${S}/arch/arm64/boot/dts/adlink/
    fi
    for extra in ${extras}; do
      extrafile=$(basename -- ${extra})
      extraname=$(echo ${extrafile%%.*})
      if [ -f ${WORKDIR}/${extrafile} ]; then
        case ${extrafile} in
        *.dtsi)
          bbnote "copy kernel dtsi: ${extrafile}"
          cp -f ${WORKDIR}/${extrafile} ${S}/arch/arm64/boot/dts/adlink/
          ;;
        *.dts)
          for dtb in ${dtbes}; do if [ "$dtb" = *"${extraname}"* ]; then dtbname=$(basename ${dtb}) else dtbname=""; fi; done
          if [ -n ${dtbname} ]; then
            bbnote "copy kernel dts: ${extrafile} for ${dtbname}"
            cp -f ${WORKDIR}/${extrafile} ${S}/arch/arm64/boot/dts/adlink/
            if [ -f ${S}/arch/arm64/boot/dts/adlink/Makefile ]; then
              if ! grep -q ${extraname} ${S}/arch/arm64/boot/dts/adlink/Makefile; then
                bbnote "Makefile: add ${dtbname}"
                echo "dtb-\$(CONFIG_ARCH_MXC) += ${dtbname}" >> ${S}/arch/arm64/boot/dts/adlink/Makefile
              fi
            fi
          fi
          ;;
        esac
      fi
    done
  fi
    if [ ${MACHINE} = "lec-imx8mp" ]; then
     cp -f ${WORKDIR}/tlv320aic3x.dtsi ${S}/arch/arm64/boot/dts/adlink/
   fi  
  
}

addtask copy_source before do_validate_branches after do_kernel_checkout

RDEPENDS_${PN} += "kernel-devsrc"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LOCALVERSION:lec-imx95 = ""
LOCALVERSION:lec-imx6 = ""
EXTRA_SRC = "${@d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
     if [ "${MACHINE}" = "lec-imx6" ]; then
        ARCH_PATH="arm"
        configs=$(echo "${IMX_KERNEL_CONFIG_ARM}" | xargs)
    else
        ARCH_PATH="arm64"
        configs=$(echo "${IMX_KERNEL_CONFIG_AARCH64}" | xargs)
    fi

  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)
  extras=$(echo "${EXTRA_SRC}" | xargs)

  # Copy main kernel build config
  if [ -n "${configs}" ]; then
    for config in ${configs}; do
      if [ -f ${UNPACKDIR}/${MACHINE}/${config} -a ! -f ${S}/arch/${ARCH_PATH}/configs/${config} ]; then
        bbnote "copy kernel build config: $config to ${S}/arch/${ARCH_PATH}/configs/${config}"
        cp -f ${UNPACKDIR}/${MACHINE}/${config} ${S}/arch/${ARCH_PATH}/configs/${config}
      fi
    done
  fi

  # copy dts, dtso and dtsi
  if [ -n "${extras}" -a -n "${dtbes}" ]; then
    if [ ! -d ${S}/arch/${ARCH_PATH}/boot/dts/adlink ]; then
      bbnote "create ${S}/arch/${ARCH_PATH}/boot/dts/adlink/ directory"
      mkdir -p ${S}/arch/${ARCH_PATH}/boot/dts/adlink/
      if [ -f ${S}/arch/${ARCH_PATH}/boot/dts/Makefile ]; then
        if ! grep -q "subdir-y.*adlink" ${S}/arch/${ARCH_PATH}/boot/dts/Makefile; then
          bbnote "Makefile: modify to build ${S}/arch/${ARCH_PATH}/boot/dts/adlink/ directory"
          echo "subdir-y += adlink" >> ${S}/arch/${ARCH_PATH}/boot/dts/Makefile
        else
          bbnote "Makefile: Already building ${S}/arch/${ARCH_PATH}/boot/dts/adlink/ directory"
        fi
      fi
    fi
    for extra in ${extras}; do
      extrafile=$(basename -- ${extra})
      extraname=$(echo ${extrafile%%.*})
      if [ -f ${UNPACKDIR}/${MACHINE}/${extrafile} ]; then
        case ${extrafile} in
        *.dtsi)
          bbnote "copy kernel dtsi: ${extrafile}"
          cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${S}/arch/${ARCH_PATH}/boot/dts/adlink/
          ;;
        *.h)
          bbnote "copy header file: ${extrafile}"
          cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${S}/arch/${ARCH_PATH}/boot/dts/adlink/
          ;;
        *.dtso)
          for dtb in ${dtbes}; do
            echo "$dtb" | grep -q "${extraname}" && \
            {
              dtbname=$(basename ${dtb})
              break
            }
          done
          if [ -n "${dtbname}" ]; then
            bbnote "copy kernel dtso: ${extrafile}"
            cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${S}/arch/${ARCH_PATH}/boot/dts/adlink/
            if ! grep -q ${extraname} ${S}/arch/${ARCH_PATH}/boot/dts/adlink/Makefile; then
              bbnote "Makefile: add ${extraname}.dtbo"
              echo "dtb-\$(CONFIG_ARCH_MXC) += ${extraname}.dtbo" >> ${S}/arch/${ARCH_PATH}/boot/dts/adlink/Makefile
            fi
          fi
          ;;
        *.dts)
          for dtb in ${dtbes}; do
            echo "$dtb" | grep -q "${extraname}" && \
            {
              dtbname=$(basename ${dtb})
              break
            }
          done
          if [ -n "${dtbname}" ]; then
            bbnote "copy kernel dts: ${extrafile} for ${dtbname}"
            cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${S}/arch/${ARCH_PATH}/boot/dts/adlink/
            if ! grep -q ${extraname} ${S}/arch/${ARCH_PATH}/boot/dts/adlink/Makefile; then
              bbnote "Makefile: add ${extraname}.dtb"
              echo "dtb-\$(CONFIG_ARCH_MXC) += ${extraname}.dtb" >> ${S}/arch/${ARCH_PATH}/boot/dts/adlink/Makefile
            fi
          fi
          ;;
        esac
      fi
    done
  fi
}

do_configure:prepend:lec-imx95() {
    sed -i 's/local no_dirty=false/local no_dirty=true/' ${S}/scripts/setlocalversion
}

do_configure:prepend:lec-imx6() {
    sed -i 's/local no_dirty=false/local no_dirty=true/' ${S}/scripts/setlocalversion
}
addtask copy_source before do_kernel_metadata after do_validate_branches

RDEPENDS:${PN} += "kernel-devsrc"

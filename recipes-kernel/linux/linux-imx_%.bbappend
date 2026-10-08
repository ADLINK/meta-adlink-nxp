FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LOCALVERSION:lec-imx95 = ""
EXTRA_SRC = "${@d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
  # Dynamically support 32-bit (IMX_KERNEL_CONFIG / KBUILD_DEFCONFIG) and 64-bit (IMX_KERNEL_CONFIG_AARCH64) variables
  configs=$(echo "${IMX_KERNEL_CONFIG:-${IMX_KERNEL_CONFIG_AARCH64:-${KBUILD_DEFCONFIG}}}" | xargs)
  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)
  extras=$(echo "${EXTRA_SRC}" | xargs)

  # Dynamically detect config directory (arm vs arm64)
  if [ -d "${S}/arch/arm/configs" ]; then
    config_dir="${S}/arch/arm/configs"
  else
    config_dir="${S}/arch/arm64/configs"
  fi

  # Copy main kernel build config
  if [ -n "${configs}" ]; then
    for config in ${configs}; do
      if [ -f ${UNPACKDIR}/${MACHINE}/${config} -a ! -f ${config_dir}/${config} ]; then
        bbnote "copy kernel build config: $config to ${config_dir}/${config}"
        mkdir -p ${config_dir}
        cp -f ${UNPACKDIR}/${MACHINE}/${config} ${config_dir}/${config}
      fi
    done
  fi

  # Dynamically detect DTS base path (arm vs arm64)
  if [ -d "${S}/arch/arm/boot/dts" ]; then
    dts_base="${S}/arch/arm/boot/dts"
  else
    dts_base="${S}/arch/arm64/boot/dts"
  fi

  # Copy dts, dtso, and dtsi files
  if [ -n "${extras}" -a -n "${dtbes}" ]; then
    if [ ! -d ${dts_base}/adlink ]; then
      bbnote "create ${dts_base}/adlink/ directory"
      mkdir -p ${dts_base}/adlink/
      if [ -f ${dts_base}/Makefile ]; then
        if ! grep -q "subdir-y.*adlink" ${dts_base}/Makefile; then
          bbnote "Makefile: modify to build ${dts_base}/adlink/ directory"
          echo "subdir-y += adlink" >> ${dts_base}/Makefile
        else
          bbnote "Makefile: Already building ${dts_base}/adlink/ directory"
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
          cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${dts_base}/adlink/
          ;;
        *.h)
          bbnote "copy header file: ${extrafile}"
          cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${dts_base}/adlink/
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
            cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${dts_base}/adlink/
            if ! grep -q ${extraname} ${dts_base}/adlink/Makefile; then
              bbnote "Makefile: add ${extraname}.dtbo"
              echo "dtb-\$(CONFIG_ARCH_MXC) += ${extraname}.dtbo" >> ${dts_base}/adlink/Makefile
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
            cp -f ${UNPACKDIR}/${MACHINE}/${extrafile} ${dts_base}/adlink/
            if ! grep -q ${extraname} ${dts_base}/adlink/Makefile; then
              bbnote "Makefile: add ${extraname}.dtb"
              # Dynamically choose config symbol based on target architecture
              if echo "${MACHINE}" | grep -q "imx6"; then
                echo "dtb-\$(CONFIG_SOC_IMX6Q) += ${extraname}.dtb" >> ${dts_base}/adlink/Makefile
              else
                echo "dtb-\$(CONFIG_ARCH_MXC) += ${extraname}.dtb" >> ${dts_base}/adlink/Makefile
              fi
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

addtask copy_source before do_kernel_metadata after do_validate_branches

RDEPENDS:${PN} += "kernel-devsrc"

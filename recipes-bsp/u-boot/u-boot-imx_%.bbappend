FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SPLASH_IMAGE ?= "splash.bmp"
UBOOT_UMS_IMAGE ?= "ums.bmp"
EXTRA_SRC = "${@d.getVarFlag('UBOOT_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
	configs=$(echo "${UBOOT_MACHINE}" | xargs)
	dtbes=$(echo "${UBOOT_DTB_NAME}" | xargs)
	srces=$(echo "${EXTRA_SRC}" | xargs)
	bbnote "u-boot dtbes: ${dtbes}, srces: ${srces}"

	# Copy config and dts
	for config in ${configs}; do
		if [ -f ${WORKDIR}/${MACHINE}/${config} ]; then
			bbnote "copy u-boot config: ${config} to ${S}/configs/"
			cp -f ${WORKDIR}/${MACHINE}/${config} ${S}/configs/
			confarch=$(grep "CONFIG_ARCH_IMX" ${S}/configs/${config} | cut -d'=' -f1)
		fi
	done
	for dtbname in ${dtbes}; do
		dtsname=$(echo "${dtbname%%.*}.dts")
		if [ -f ${WORKDIR}/${MACHINE}/${dtsname} ]; then
			bbnote "copy u-boot dts: ${dtsname} to ${S}/arch/arm/dts/"
			cp -f ${WORKDIR}/${MACHINE}/${dtsname} ${S}/arch/arm/dts/
			if ! grep -q ${dtbname} ${S}/arch/arm/dts/Makefile; then
				bbnote "modify ${S}/arch/arm/dts/Makefile: add ${dtbname} to dtb-\$(${confarch})"
				echo "dtb-\$(${confarch}) += ${dtbname}" >> ${S}/arch/arm/dts/Makefile
			fi
		fi
	done
	for src in ${srces}; do
		srcfile=$(basename -- ${src} | xargs)
		case "${srcfile}" in
		*.dtsi)
			if [ -f ${WORKDIR}/${MACHINE}/${srcfile} ]; then
				bbnote "copy u-boot dtsi: ${srcfile} to ${S}/arch/arm/dts/"
				cp -f ${WORKDIR}/${MACHINE}/${srcfile} ${S}/arch/arm/dts/
			fi
			;;
		esac
	done
}
addtask copy_source before do_patch after do_unpack

do_replace () {
	# replace printf Bad has value to show calculated hashes
	sed -e 's|memcmp(value, (const void \*)fit_hash,|memcmp(value, value,|g' -i ${S}/arch/arm/mach-imx/spl.c
}
addtask replace before do_extra_configure after do_patch

do_replace:append:debug () {
	sed -e 's|43000000|45000000|g' -i ${S}/include/configs/sp2imx8mp.h
}

python do_extra_configure () {
  # Additional CONFIG_XXX for u-boot config
  # E.g. in local.conf
  #     UBOOT_EXTRA_CONFIGS = "LPDDR4_8GB"
  # For imx8mq:
  #     DDR3L_1GB, DDR3L_2GB, DDR3L_4GB, DDR3L_4GB_MT
  # For imx8mp:
  #     LPDDR4_2GB, LPDDR4_2GK, LPDDR4_4GB, LPDDR4_8GB
  import shlex
  bb.note(f"Add UBOOT_EXTRA_CONFIGS to UBOOT Config file")
  configs = d.getVar('UBOOT_MACHINE', True)
  extras = shlex.split(d.getVar('UBOOT_EXTRA_CONFIGS', True))
  srcdir = d.getVar('S', True)
  bb.note(f"srcdir: {srcdir} configs:{configs}")
  for extra in extras:
    for config in configs.split():
      with open(f"{srcdir}/configs/{config}", "a") as file:
        bb.note(f"add {extra} to {config}")
        if (extra.startswith("NO_")):
          file.write(f"CONFIG_{extra.lstrip('CONFIG_').upper()}=n\n")
        elif ('=' in extra):
          if ' ' in extra.split('=')[1]:
            file.write(f"CONFIG_{extra.split('=')[0].lstrip('CONFIG_').upper()}=\"{extra.split('=')[1]}\"\n")
          else:
            file.write(f"CONFIG_{extra.lstrip('CONFIG_').upper()}\n")
        else:
          file.write(f"CONFIG_{extra.lstrip('CONFIG_').upper()}=y\n")
        file.close()
}
addtask extra_configure before do_configure after do_replace

do_install:append () {
	install -d ${DEPLOY_DIR_IMAGE}
	if [ -f ${WORKDIR}/${MACHINE}/${UBOOT_SPLASH_IMAGE} ]; then
		install -m 0644 ${WORKDIR}/${MACHINE}/${UBOOT_SPLASH_IMAGE} ${DEPLOY_DIR_IMAGE}/${UBOOT_SPLASH_IMAGE}
	else
		bbwarn "${S}/${UBOOT_SPLASH_IMAGE} not found. No splash image for u-boot"
	fi
	if [ -f ${WORKDIR}/${MACHINE}/${UBOOT_UMS_IMAGE} ]; then
		install -m 0644 ${WORKDIR}/${MACHINE}/${UBOOT_UMS_IMAGE} ${DEPLOY_DIR_IMAGE}/${UBOOT_UMS_IMAGE}
	else
		bbwarn "${S}/${UBOOT_UMS_IMAGE} not found. No ums image for u-boot"
	fi
}


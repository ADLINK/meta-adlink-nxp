DEPENDS += "bc-native util-linux-native imx-cst-native"

CACERT_REPO ?= "git://github.com/ADLINK/adlink-ca-certs.git"
CACERT_BRANCH ?= "adlink"
CACERT_DEST ?= "cacert"

KERNEL_SRC = "git://github.com/nxp-imx/linux-imx.git;protocol=https;branch=${SRCBRANCH};name=knlimg;"
CACERT_SRC = "${CACERT_REPO};protocol=https;branch=${CACERT_BRANCH};name=cacert;destsuffix=${CACERT_DEST};"

SRCREV_FORMAT = "knlimg_cacert"
SRCREV_knlimg = "b586a521770e508d1d440ccb085c7696b9d6d387"
SRCREV_cacert = "95ebc7164b693447cbfeb9dc3e52b8a1db3515eb"

SRC_URI:append = " \
    ${CACERT_SRC} \
    file://genIVT \
    file://default.csf \
    file://align_image.sh \
    file://mx8_create_csf.sh \
    file://mx8_template.csf \
    "

# Define SIGN_DTB to authenticate device tree
# Optional: imx8m family
# Required: imx8qm and imx8qxp
SIGN_DTB:mx8qm-nxp-bsp ?= "${B}/${KERNEL_OUTPUT_DIR}/dts/freescale/imx8qm-mek-cockpit-a72.dtb"
SIGN_DTB:mx8x-nxp-bsp ?= "${B}/${KERNEL_OUTPUT_DIR}/dts/freescale/imx8qxp-colibri-eval-v3.dtb"

# CONFIG_SYS_LOAD_ADDR from u-boot-imx config
LOAD_ADDR_KERNEL ?= "0x40400000"
LOAD_ADDR_DTB ?= "0x43000000"
#LOAD_ADDR_KERNEL:mx8m-nxp-bsp ?= "0x40480000"
#LOAD_ADDR_DTB:mx8m-nxp-bsp ?= "0x43000000"
#LOAD_ADDR_KERNEL:mx8-nxp-bsp ?= "0x80200000"
#LOAD_ADDR_DTB:mx8-nxp-bsp ?= "0x83000000"

MKIMG_SOC:mx8qm-nxp-bsp="QM"
MKIMG_SOC:mx8x-nxp-bsp="QX"

CST_KEYS_PATH ?= "${WORKDIR}/${CACERT_DEST}/keys"
CST_SRK_PATH ?= "${WORKDIR}/${CACERT_DEST}/crts"
CST_CA_PATH ?= "${WORKDIR}/${CACERT_DEST}/ca"

FUSE_BIN ?= "fuse.bin"
CST_SRK_FUSE ?= "${CST_SRK_PATH}/${FUSE_BIN}"
TABLE_BIN ?= "table.bin"
CST_SRK ?= "${CST_SRK_PATH}/${TABLE_BIN}"

CST_EXPIRY_PERIOD ?= "5"
CST_SRK_NUMBERS ?= "4"
CST_KEY_LENGTH ?= "2048"
CST_KEY_NAME ?= "SRK1_sha256_2048_65537_v3_ca_key.pem"
CST_KEY ?= "${CST_KEYS_PATH}/${CST_KEY_NAME}"
CST_CSF_CERT_NAME ?= "CSF1_1_sha256_2048_65537_v3_usr_crt.pem"
CST_CSF_CERT ?= "${CST_SRK_PATH}/${CST_CSF_CERT_NAME}"
CST_IMG_CERT_NAME ?= "IMG1_1_sha256_2048_65537_v3_usr_crt.pem"
CST_IMG_CERT ?= "${CST_SRK_PATH}/${CST_IMG_CERT_NAME}"

# Depend on ${DEPLOY_DIR_IMAGE}/table.bin
do_recycle_srk_table_fuse[depends] = " \
    imx-cst-native:do_populate_sysroot \
    coreutils-native:do_populate_sysroot \
    imx-boot:do_deploy \
"
do_recycle_srk_table_fuse () {
    bbnote "Re-use SRK table and fuse table generated from imx-boot"
    if [ -f ${DEPLOY_DIR_IMAGE}/${TABLE_BIN} ]; then
        cp ${DEPLOY_DIR_IMAGE}/${TABLE_BIN} ${CST_SRK}
    fi
    if [ -f ${DEPLOY_DIR_IMAGE}/${FUSE_BIN} ]; then
        cp ${DEPLOY_DIR_IMAGE}/${FUSE_BIN} ${CST_SRK_FUSE}
    fi
}
addtask recycle_srk_table_fuse before do_compile after do_configure

# Generate HAB block for a file
# Inputs: Start Address, File Path
# Outputs: "<start address> 0x0 <file size> <relative path to file>"
create_hab_block() {
    START_ADDR=$1
    FILE_PATH=$2
    FILE_PATH_RELATIVE=$(realpath --relative-to=${WORKDIR} $2)
    FILE_SIZE=$(printf "0x%08x\n" `stat -c "%s" ${FILE_PATH}`)
    BLOCK=$(printf "0x%08x 0x%08x 0x%08x \"%s\"" "${START_ADDR}" "0x0" "${FILE_SIZE}" "${FILE_PATH_RELATIVE}")
    bbnote "Created HAB Block: ${BLOCK}"
    echo ${BLOCK}
}

create_csf_habv4() {
    CSF=$1

    # Copy Template
    cp ${WORKDIR}/default.csf ${CSF}

    # Update keys from template
    sed -i "s|@CST_SRK@|$(realpath --relative-to=${WORKDIR} ${CST_SRK})|g" ${CSF}
    sed -i "s|@CST_CSF_CERT@|$(realpath --relative-to=${WORKDIR} ${CST_CSF_CERT})|g" ${CSF}
    sed -i "s|@CST_IMG_CERT@|$(realpath --relative-to=${WORKDIR} ${CST_IMG_CERT})|g" ${CSF}

    # Add Block(s)
    # --- Add kernel block:
    HAB_BLOCK_KERNEL=$(create_hab_block ${LOAD_ADDR_KERNEL} ${B}/${KERNEL_OUTPUT_DIR}/Image_pad_ivt)

    # --- Add device tree block (Optional):
    if [ -n "${SIGN_DTB}" ]; then
        if [ ! -f "${SIGN_DTB}" ]; then
            bbfatal "${SIGN_DTB} not found"
        fi

        # Append ", \" to kernel block for proper syntax
        HAB_BLOCK_KERNEL="${HAB_BLOCK_KERNEL}, \\"

        # Pad DTB
        ${WORKDIR}/align_image.sh ${SIGN_DTB}
        cp ${SIGN_DTB}-pad ${SIGN_DTB}

        # Add DTB block
        HAB_BLOCK_DTB=$(create_hab_block ${LOAD_ADDR_DTB} ${SIGN_DTB})
    fi

    # --- Write blocks to CSF file:
    echo "    Blocks = ${HAB_BLOCK_KERNEL}" >> ${CSF}
    echo "             ${HAB_BLOCK_DTB}" >> ${CSF}
}

# Follows "Authenticating the OS container" from:
# https://github.com/varigit/uboot-imx/blob/imx_v2020.04_5.4.24_2.1.0_var02/doc/imx/ahab/guides/mx8_mx8x_secure_boot.txt
do_sign_kernel_ahab() {
    MKIMG="${DEPLOY_DIR_IMAGE}/imx-boot-tools/mkimage_imx8"
    MKIMG_LOG="${WORKDIR}/mkimage.log"
    IMG=${B}/${KERNEL_OUTPUT_DIR}/Image

    # Generate the OS container image
    ${MKIMG} -soc ${MKIMG_SOC} -rev B0 -c -ap ${IMG} a35 ${LOAD_ADDR_KERNEL} \
        --data ${SIGN_DTB} a53 ${LOAD_ADDR_DTB} -out ${WORKDIR}/flash_os.bin > ${MKIMG_LOG}

    TARGET="linux_container"

    # Sign u-boot-atf-container.img, so flash.bin will use the signed version
    bbnote "${WORKDIR}/mx8_create_csf.sh -t ${TARGET}"
    CST_SRK="$(realpath --relative-to=${WORKDIR} ${CST_SRK})" \
    CST_KEY="$(realpath --relative-to=${WORKDIR} ${CST_KEY})" \
    CST_BIN="$(realpath --relative-to=${WORKDIR} ${CST_BIN})" \
    IMAGE="$(realpath --relative-to=${WORKDIR} ${WORKDIR}/flash_os.bin)" \
    LOG_MKIMAGE="${MKIMG_LOG}" \
    ${WORKDIR}/mx8_create_csf.sh -t ${TARGET}

    # Rename to os_cntr_signed.bin expected by U-Boot bootcmd
    mv ${WORKDIR}/flash_os.bin-signed ${WORKDIR}/os_cntr_signed.bin
}

# Follows "Authenticating additional boot images" from:
# https://github.com/varigit/uboot-imx/blob/imx_v2020.04_5.4.24_2.1.0_var02/doc/imx/habv4/guides/mx8m_secure_boot.txt
do_sign_kernel_habv4() {
    IMG_ADDR=${LOAD_ADDR_KERNEL}
    IMG=${B}/${KERNEL_OUTPUT_DIR}/Image
    IMG_NAME=$(basename ${IMG})
    LOGFILE=${WORKDIR}/${IMG_NAME}.log
    CST_BIN=$(which cst)

    # Read kernel image size:
    IMG_SIZE=$(od -x -j 0x10 -N 0x4 --endian=little ${IMG} | awk 'NR==1 { print "0x"$3 $2 }')

    # Pad kernel image:
    objcopy -I binary -O binary --pad-to ${IMG_SIZE} --gap-fill=0x00 ${IMG} ${IMG}_pad
    bbnote "Pad Kernel Image to size: ${IMG_SIZE}"

    # Generate IVT:
    (cd ${WORKDIR} && ./genIVT ${LOAD_ADDR_KERNEL} `printf "0x%x" ${IMG_SIZE}`)

    # Append the ivt.bin at the end of the padded Image:
    cat ${IMG}_pad ${WORKDIR}/ivt.bin > ${IMG}_pad_ivt

    # Create csf for signing
    create_csf_habv4 ${IMG}.csf

    # Create signature
    cd ${WORKDIR} && ${CST_BIN} -i ${IMG}.csf -o ${IMG}.csf.bin

    # Attach signature to Image_signed
	cat ${IMG}_pad_ivt ${IMG}.csf.bin > ${IMG}_signed

    # Create final signed Image.gz
    gzip -f -k ${IMG}_signed

    # Manually authenticate:
    # u-boot> hab_auth_img ${IMG_ADDR} $filesize ${IMG_SIZE}
    # Write file with example commands:
    echo "The following is an example for how to manually authenticate an image:" > ${IMG}.gz.uboot-cmds
    echo >> ${IMG}.gz.uboot-cmds
    echo "u-boot> tftp \${img_addr} ${IMG_NAME}.gz;unzip \${img_addr} \${loadaddr};" >> ${IMG}.gz.uboot-cmds
    echo "u-boot> hab_auth_img \${loadaddr} \$filesize ${IMG_SIZE}" >> ${IMG}.gz.uboot-cmds
}

# Empty function for when hab override not defined
do_sign_kernel() {
    if [ -n "${HAB_VER}" ]; then
        do_sign_kernel_${HAB_VER}
    fi
}
addtask sign_kernel after do_compile before do_install

do_install:append() {
    # Install os_cntr_signed.bin for ahab SoCs
    if [ "ahab" = "${HAB_VER}" ]; then
        install -d ${D}/${KERNEL_IMAGEDEST}
        install -m 0644 ${WORKDIR}/os_cntr_signed.bin \
            ${D}/${KERNEL_IMAGEDEST}/os_cntr_signed.bin-${KERNEL_VERSION}
        ln -sf os_cntr_signed.bin-${KERNEL_VERSION} ${D}/${KERNEL_IMAGEDEST}/os_cntr_signed.bin
    fi
}

do_deploy:append() {
    # Deploy Image U-boot Manual Authentication Commands
    IMG=${B}/${KERNEL_OUTPUT_DIR}/Image
    bbnote "Deploy signed Image associated files"
    install -m 0644 ${IMG} ${DEPLOYDIR}/Image_unsigned
    install -m 0644 ${IMG}_signed ${DEPLOYDIR}/Image_signed
    install -m 0644 ${IMG}.gz.uboot-cmds ${DEPLOYDIR}
    install -m 0644 ${IMG}_signed.gz ${DEPLOYDIR}
    install -m 0644 ${IMG}.csf ${DEPLOYDIR}
    install -m 0644 ${IMG}.csf.bin ${DEPLOYDIR}
    install -m 0644 ${IMG}_pad ${DEPLOYDIR}
    install -m 0644 ${WORKDIR}/ivt.bin ${DEPLOYDIR}
    install -m 0644 ${IMG}_pad_ivt ${DEPLOYDIR}
    # Copy over signed Image to Image to be packaged
    install -m 0644 ${IMG}_signed ${DEPLOYDIR}/Image
}

FILES:${KERNEL_PACKAGE_NAME}-image:mx8qm-nxp-bsp += "/boot/os_cntr_signed.bin*"
FILES:${KERNEL_PACKAGE_NAME}-image:mx8x-nxp-bsp += "/boot/os_cntr_signed.bin*"

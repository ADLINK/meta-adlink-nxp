DEPENDS += "bc-native util-linux-native imx-cst-native"

CACERT_REPO ?= "git://github.com/ADLINK/adlink-ca-certs.git"
CACERT_BRANCH ?= "adlink"
CACERT_DEST ?= "cacert"

#SRC_URI = "${IMX_MKIMAGE_SRC};branch=${SRCBRANCH}
#IMX_MKIMAGE_SRC = "git://github.com/nxp-imx/imx-mkimage.git;protocol=https;name=mkimg;"
SRCBRANCH = "lf-6.6.23_2.0.0;name=mkimg"
CACERT_SRC = "${CACERT_REPO};protocol=https;branch=${CACERT_BRANCH};name=cacert;destsuffix=${CACERT_DEST};"

SRCREV_FORMAT = "mkimg_cacert"
SRCREV_mkimg = "ca5d6b2d3fd9ab15825b97f7ef6f1ce9a8644966"
SRCREV_cacert = "95ebc7164b693447cbfeb9dc3e52b8a1db3515eb"

SRC_URI:append = " \
    ${CACERT_SRC} \
    file://mx8m_create_csf.sh \
    file://mx8m_template.csf \
    file://mx8_create_csf.sh \
    file://mx8_template.csf \
    file://mx8_create_fuse_commands.sh \
"

UBOOT_DTBS ?= "${UBOOT_DTB_NAME}"
UBOOT_DTBS_TARGET ?= "dtbs"

# Name of the image to include in final image
# e.g. imx-boot-imx8mn-sd.bin-flash_ddr4_evk-signed
UBOOT_DTB_DEFAULT ?= ""

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

# Override in local.conf with customer serial & password
CST_KEYPASS ?= ""
CST_SERIAL ?= ""

do_generate_key_certs[depends] += " \
  imx-cst-native:do_populate_sysroot \
  coreutils-native:do_populate_sysroot \
  openssl:do_populate_sysroot \
  u-boot-imx:do_deploy \
"
do_generate_key_certs () {
    # Prepare serial and key_pass files with secrets
    if [ -n "${CST_KEYPASS}" ]; then
        echo "${CST_KEYPASS}" > ${CST_KEYS_PATH}/key_pass.txt
        echo "${CST_KEYPASS}" >> ${CST_KEYS_PATH}/key_pass.txt
    fi
    if [ -n "${CST_SERIAL}" ]; then
        echo "${CST_SERIAL}" > ${CST_KEYS_PATH}/serial
    fi
    # copy hab4_pki_tree.sh to ${WORKDIR}/${CACERT_DEST}/keys and run it from there
    mkdir -p ${CST_KEYS_PATH}
    mkdir -p ${CST_SRK_PATH}
    mkdir -p ${CST_CA_PATH}
    SCRIPTFILE=$(which hab4_pki_tree.sh)
    SCRIPTPATH=$(dirname ${SCRIPTFILE})
    cp -f ${SCRIPTFILE} ${CST_KEYS_PATH}
    cp -f ${SCRIPTPATH}/../../${datadir}/ca/*.cnf ${CST_CA_PATH}
    # use hab4_pki_tree.sh script from cst_3.3.1 to generate keys and certificates
    # -existing-ca n        ===> no existing ca
    # -use-ecc n            ===> no elliptic curve
    # -kl 2048              ===> key length of 2048
    # -duration 5           ===> 5 years
    # -num-srk 4            ===> Number of SRKs to generate
    # -srk-ca y             ===> Generated as CA certificate (or user certificates)
    if [ -f ${CST_KEY} -a -f ${CST_CSF_CERT} -a -f ${CST_IMG_CERT} ]; then
        bbnote "Existing keys and certificates found."
    else
	    bbnote "Generate keys and certificates."
        cd ${WORKDIR}
        ./${CACERT_DEST}/keys/hab4_pki_tree.sh -existing-ca n -use-ecc n -kl ${CST_KEY_LENGTH} -duration ${CST_EXPIRY_PERIOD} -num-srk ${CST_SRK_NUMBERS} -srk-ca y
	fi
}
addtask generate_key_certs before do_generate_srk_table_fuse after do_patch

do_generate_srk_table_fuse () {
    # use srktool to generate srk table and fuse maps
    # ../linux64/bin/srktool -h 4 -d sha256 -t table.bin -e fuse.bin -c \
    # SRK1_sha256_2048_65537_v3_ca_crt.pem,\
    # SRK2_sha256_2048_65537_v3_ca_crt.pem,\
    # SRK3_sha256_2048_65537_v3_ca_crt.pem,\
    # SRK4_sha256_2048_65537_v3_ca_crt.pem
    bbnote "Generate SRK table and fuse table"
    cd ${WORKDIR}/${CACERT_DEST}/crts
    srktool -h 4 -d sha256 -t table.bin -e fuse.bin -c \
    SRK1_sha256_2048_65537_v3_ca_crt.pem,\
    SRK2_sha256_2048_65537_v3_ca_crt.pem,\
    SRK3_sha256_2048_65537_v3_ca_crt.pem,\
    SRK4_sha256_2048_65537_v3_ca_crt.pem | tee ${WORKDIR}/srktool.log
}
addtask generate_srk_table_fuse before do_configure after do_generate_srk_table_fuse

do_replace:append () {
    #
    # redirect make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} dtbs=${UBOOT_DTB_NAME} ${target} output to MKIMAGE_LOG="mkimage-${target}${DTB_SUFFIX}"
    # via the soc.mak, as we don't want to make SOC=flash-evk twice in do_compile
    #
    for target in ${IMXBOOT_TARGETS}; do
        for uboot_dtb in ${UBOOT_DTBS}; do
            # If UBOOT_DTBS has more then one dtb, include in imx-boot filename
            # Currently, for imx8m, hab only supports a single U-Boot proper dtb
            if [ "$(echo ${UBOOT_DTBS} | wc -w)" -gt "1" ]; then
                DTB_SUFFIX="-${uboot_dtb%.*}"
            else
                DTB_SUFFIX=""
            fi

            if [ "$target" = "flash_evk" ]; then
                # Prepare log file name for redirection
                MKIMAGE_LOG=${WORKDIR}/mkimage-${target}${DTB_SUFFIX}.log
                sed -E "s|(./mkimage_imx8 -version.*-second_loader u-boot.itb.*$)|\1 > ${MKIMAGE_LOG} 2>\&1|g" -i ${BOOT_STAGING}/soc.mak
            fi
        done
    done
}

sign_uboot_atf_container_ahab () {
    TARGET=$1
    IMAGE=$2
    LOG_MKIMAGE="${BOOT_STAGING}/${TARGET}.log"

    # Create u-boot-atf-container.img
    compile_${SOC_FAMILY}
    make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} ${UBOOT_DTBS_TARGET}=${UBOOT_DTB_NAME} ${TARGET} > ${LOG_MKIMAGE} 2>&1

    # Create u-boot-atf-container.img-signed for flash.bin image
    CST_SRK="${CST_SRK}" \
    CST_KEY="${CST_KEY}" \
    CST_BIN="$(which cst)" \
    IMAGE="${IMAGE}" \
    LOG_MKIMAGE="${LOG_MKIMAGE}" \
    ${WORKDIR}/mx8_create_csf.sh -t ${TARGET}
}

sign_flash_ahab () {
    TARGET=$1
    LOG_MKIMAGE_PREFIX="$2"

    # Sign u-boot-atf-container.img, so flash.bin will use the signed version
    bbnote "${WORKDIR}/mx8_create_csf.sh -t ${TARGET}"
    CST_SRK="${CST_SRK}" \
    CST_KEY="${CST_KEY}" \
    CST_BIN="$(which cst)" \
    IMAGE="${BOOT_STAGING}/flash.bin" \
    LOG_MKIMAGE="${LOG_MKIMAGE_PREFIX}.log" \
    ${WORKDIR}/mx8_create_csf.sh -t ${TARGET}
    bbnote "Copy ${BOOT_STAGING}/flash.bin-signed to ${S}/${BOOT_CONFIG_MACHINE}-${TARGET}-signed"
    cp ${BOOT_STAGING}/flash.bin-signed ${S}/${BOOT_CONFIG_MACHINE}-${TARGET}-signed
}

sign_flash_habv4 () {
    TARGET=$1
    LOG_MKIMAGE_PREFIX="$2"

    # Generate csf spl and fit files
    CST_SRK="${CST_SRK}" \
    CST_CSF_CERT="${CST_CSF_CERT}" \
    CST_IMG_CERT="${CST_IMG_CERT}" \
    CST_BIN="$(which cst)" \
    IMXBOOT="${S}/${BOOT_CONFIG_MACHINE}-${TARGET}" \
    LOG_MKIMAGE="${LOG_MKIMAGE_PREFIX}.log" \
    LOG_PRINT_FIT_HAB="${LOG_MKIMAGE_PREFIX}.hab" \
    ${WORKDIR}/mx8m_create_csf.sh -t ${TARGET}

    offset_spl="$(cat ${LOG_MKIMAGE_PREFIX}.log | grep -w " csf_off" | awk '{print $NF}')"
    offset_fit="$(cat ${LOG_MKIMAGE_PREFIX}.log | grep -w " sld_csf_off" | awk '{print $NF}')"
    bbnote "offset_spl: ${offset_spl}, offset_fit: ${offset_fit}"

    # Copy imx-boot image
    IMG_ORIG="${S}/${BOOT_CONFIG_MACHINE}-${TARGET}"
    IMG_SIGNED="${S}/${BOOT_CONFIG_MACHINE}-${TARGET}-signed"
    cp ${IMG_ORIG} ${IMG_SIGNED}

    # Insert SPL and FIT Signatures
    dd if=${WORKDIR}/${TARGET}-csf-spl.bin of=${IMG_SIGNED} seek=$(printf "%d" ${offset_spl}) bs=1 conv=notrunc
    dd if=${WORKDIR}/${TARGET}-csf-fit.bin of=${IMG_SIGNED} seek=$(printf "%d" ${offset_fit}) bs=1 conv=notrunc
}

do_compile:append () {
    for target in ${IMXBOOT_TARGETS}; do
        for uboot_dtb in ${UBOOT_DTBS}; do
            # If UBOOT_DTBS has more then one dtb, include in imx-boot filename
            # Currently, for imx8m, hab only supports a single U-Boot proper dtb
            if [ "$(echo ${UBOOT_DTBS} | wc -w)" -gt "1" ]; then
                DTB_SUFFIX="-${uboot_dtb%.*}"
            else
                DTB_SUFFIX=""
            fi

            if [ "$target" = "flash_evk" ]; then
                # Prepare log file name
                MKIMAGE_LOG="mkimage-${target}${DTB_SUFFIX}"

                # mx8qm-nxp-bsp|mx8x: Sign u-boot-atf-container.img, so flash.bin will use the signed version
                if [ "${SOC_FAMILY}" = "mx8" ] || [ "${SOC_FAMILY}" = "mx8x" ]; then
                    sign_uboot_atf_container_ahab u-boot-atf-container.img ${BOOT_STAGING}/u-boot-atf-container.img
                fi

                # mx8m: run print_fit_hab
                if [ "${SOC_FAMILY}" = "mx8m" ]; then
                    # Create print_fit_hab log for create_csf.sh
                    cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/*.dtb   ${BOOT_STAGING}
                    make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} ${UBOOT_DTBS_TARGET}=${uboot_dtb} print_fit_hab > ${WORKDIR}/${MKIMAGE_LOG}.hab 2>&1
                fi

                if [ -e "${BOOT_STAGING}/flash.bin" ]; then
                    cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}${DTB_SUFFIX}
                    cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}-unsigned
                fi

                bbnote "Sign_flash_${HAB_VER}: Sign flash.bin for secure boot"
                sign_flash_${HAB_VER} ${target}${DTB_SUFFIX} ${WORKDIR}/${MKIMAGE_LOG}
            fi
        done
    done

    # Generate file with instructions for programming fuses
    bbnote "Generate fuse u-boot cmd: ${FUSE_BIN}.u-boot-cmds"
    ${WORKDIR}/mx8_create_fuse_commands.sh ${SOC_FAMILY} ${CST_SRK_FUSE} ${FUSE_BIN}.u-boot-cmds
}

do_deploy:append () {
    # deploy table.bin for kernel build
    if [ -f ${CST_SRK} ]; then
        install -m 0644 ${CST_SRK} ${DEPLOY_DIR_IMAGE}
    fi
    if [ -f ${CST_SRK_FUSE} ]; then
        install -m 0644 ${CST_SRK_FUSE} ${DEPLOY_DIR_IMAGE}
    fi

    # Deploy imx-boot signed images
    for target in ${IMXBOOT_TARGETS}; do
        for uboot_dtb in ${UBOOT_DTBS}; do
            if [ "$(echo ${UBOOT_DTBS} | wc -w)" -gt "1" ]; then
                DTB_SUFFIX="-${uboot_dtb%.*}"
            else
                DTB_SUFFIX=""
            fi
            install -m 0644 ${WORKDIR}/mkimage-${target}${DTB_SUFFIX}.log ${DEPLOY_DIR_IMAGE}
            install -m 0644 ${WORKDIR}/mkimage-${target}${DTB_SUFFIX}.hab ${DEPLOY_DIR_IMAGE}
            if [ -f ${WORKDIR}/${target}-csf-spl.bin ]; then
                install -m 0644 ${WORKDIR}/${target}-csf-spl.csf ${DEPLOY_DIR_IMAGE}
                install -m 0644 ${WORKDIR}/${target}-csf-spl.bin ${DEPLOY_DIR_IMAGE}
                install -m 0644 ${WORKDIR}/${target}-csf-spl.log ${DEPLOY_DIR_IMAGE}
            fi
            if [ -f ${WORKDIR}/${target}-csf-fit.bin ]; then
                install -m 0644 ${WORKDIR}/${target}-csf-fit.csf ${DEPLOY_DIR_IMAGE}
                install -m 0644 ${WORKDIR}/${target}-csf-fit.bin ${DEPLOY_DIR_IMAGE}
                install -m 0644 ${WORKDIR}/${target}-csf-fit.log ${DEPLOY_DIR_IMAGE}
            fi

            # Deploy signed imx-boot image for each U-Boot Device Tree
            bbnote "Deploy ${BOOT_CONFIG_MACHINE}-${target}${DTB_SUFFIX}-signed"
            install -m 0644 ${S}/${BOOT_CONFIG_MACHINE}-${target}${DTB_SUFFIX}-signed \
                ${DEPLOYDIR}/${BOOT_CONFIG_MACHINE}-${target}${DTB_SUFFIX}-signed
        done
        # Deploy default signed imx-boot image for sdcard image (following uuu_bootloader_tag.bbclass)
        cp ${S}/${BOOT_CONFIG_MACHINE}-${target}${DTB_SUFFIX}-signed ${DEPLOYDIR}/${UUU_BOOTLOADER_TAGGED}
        cp ${S}/${BOOT_CONFIG_MACHINE}-${target}${DTB_SUFFIX}-signed ${DEPLOYDIR}/${UUU_BOOTLOADER_UNTAGGED}
        ln -sf ${UUU_BOOTLOADER_TAGGED}     ${DEPLOYDIR}/${UUU_BOOTLOADER}
        stat -L -cUUUBURNXXOEUZX7+A-XY5601QQWWZ%sEND ${DEPLOYDIR}/${UUU_BOOTLOADER_TAGGED} \
                                         >> ${DEPLOYDIR}/${UUU_BOOTLOADER_TAGGED}
    done

    # Deploy U-Boot Fuse Commands
    bbnote "Deploy ${FUSE_BIN}.u-boot-cmds"
    install -m 0644 ${S}/${FUSE_BIN}.u-boot-cmds ${DEPLOYDIR}
}


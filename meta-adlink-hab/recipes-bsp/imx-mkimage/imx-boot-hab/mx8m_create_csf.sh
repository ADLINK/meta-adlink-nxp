#!/bin/bash

set -e

readonly FILE_SCRIPT="$(basename "$0")"
readonly DIR_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

help() {
    if [ -n "${1}" ]; then
        echo " Error: ${1}"
    fi
    echo
    echo " Usage: ${DIR_SCRIPT}/${FILE_SCRIPT} <options>"
    echo
    echo " Required Environment Variables:"
    echo
    echo "    CST_SRK                   Path to SRK Table,                e.g. SRK_1_2_3_4_table.bin"
    echo "    CST_CSF_CERT              Path to CSFK Certificate,         e.g. CSF1_1_sha256_4096_65537_v3_usr_crt.pem"
    echo "    CST_IMG_CERT              Path to Public key certificate,   e.g. IMG1_1_sha256_4096_65537_v3_usr_crt.pem"
    echo "    CST_BIN                   Path to NXP CST Binary            e.g. cst-3.1.0/release/linux64/bin/cst"
    echo "    IMXBOOT                   Path to unsigned imx-boot image,  e.g. imx-boot-imx8mn-var-som-sd.bin-flash_ddr4_evk"
    echo "    LOG_MKIMAGE               Path to mkimage log file"
    echo "    LOG_PRINT_FIT_HAB         Path to mkimage print_fit_hab log file"
    echo
    echo " required arguments:"
    echo "    -t --target                imx-boot target, e.g. imx8mn-var-som-sd.bin-flash_ddr4_evk"
    echo
    echo " optional:"
    echo "    -h --help            display this Help message"
    echo
    exit 1
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                help
            ;;
            -t|--target)
                TARGET="$2"
                shift # past argument
                shift # past value
            ;;
            *)    # unknown option
                echo "Unknown option: $1"
                help
            ;;
        esac
    done
}

# Verify environment variable is set and file exists
verify_env() {
    if [ -z "$1" ]; then
        help "Please set environment variable '$2'"
    fi
    if [ ! -f $1 ]; then
        help "Could not find '$1'"
    fi
	echo "Verified $2=$1"
}

generate_csf_spl() {
    # Copy template file
    cp ${DIR_SCRIPT}/mx8m_template.csf ${CSF_SPL}.csf

    # Delete 'Blocks =' section from template
    sed -i '/Blocks = /d' ${CSF_SPL}.csf

    # Update Key Locations
    sed -i "s|CST_SRK|${CST_SRK}|g" ${CSF_SPL}.csf
    sed -i "s|CST_CSF_CERT|${CST_CSF_CERT}|g" ${CSF_SPL}.csf
    sed -i "s|CST_IMG_CERT|${CST_IMG_CERT}|g" ${CSF_SPL}.csf

    # Append Blocks
    echo "    Blocks = $(grep 'spl hab block' ${LOG_MKIMAGE} | awk '{print $4, $5, $6}') \"${IMXBOOT}\"" >> ${CSF_SPL}.csf

    # Generate Binary
    ${CST_BIN} -i ${CSF_SPL}.csf -o ${CSF_SPL}.bin > ${CSF_SPL}.log 2>&1
	cat ${CSF_SPL}.log
}

generate_csf_fit() {
    # Use SPL CSF as template
    cp ${CSF_SPL}.csf ${CSF_FIT}.csf

    # Delete 'Blocks =' section from template
    sed -i '/Blocks = /d' ${CSF_FIT}.csf

    # Delete [Unlock] section for fit image
    sed -i '/\[Unlock\]/{N;N;N;N;d;}' ${CSF_FIT}.csf

    # Append Blocks

    # Append block from mkimage log
    echo "    Blocks = $(grep 'sld hab block' ${LOG_MKIMAGE} | awk '{print $4, $5, $6}') \"${IMXBOOT}\", \\" >> ${CSF_FIT}.csf

    # Append blocks from mkimage print_fit_hab
    # It looks like this, with a variable number of lines after TEE_LOAD_ADDR....
    # TEE_LOAD_ADDR=0xbe000000 ATF_LOAD_ADDR=0x00920000 VERSION=v1 ./print_fit_hab.sh 0x60000 imx8mm-var-dart-customboard.dtb imx8mm-var-som-symphony.dtb
    # 0x40200000 0x5AC00 0xA8F90
    # 0x402A8F90 0x103B90 0x7942
    # 0x402B08D2 0x10B4D4 0x7AEA
    # 0x920000 0x112FC0 0xA1E0

    # Read to end of file
    BLOCKS_RAW="$(sed -n '/TEE_LOAD_ADDR=/,$p' ${LOG_PRINT_FIT_HAB})"
    # Split each newline into array
    readarray -t BLOCKS <<<"$BLOCKS_RAW"
    # Remove first line
    unset BLOCKS[0]
    # Loop through each line
    PREFIX=""
    for BLOCK in "${BLOCKS[@]}"; do
        printf "${PREFIX}             ${BLOCK} \"${IMXBOOT}\"" >> ${CSF_FIT}.csf
        PREFIX=", \\ \n"
    done
    echo "" >> ${CSF_FIT}.csf

    # Generate Binary
    ${CST_BIN} -i ${CSF_FIT}.csf -o ${CSF_FIT}.bin > ${CSF_FIT}.log 2>&1
	cat ${CSF_FIT}.log
}

parse_args "$@"

# Print command for Yocto logs
echo $0 "$@"

# Verify required variables
if [ -z "${TARGET}" ]; then
    help "target argument required"
fi
verify_env "${CST_SRK}" "CST_SRK"
verify_env "${CST_CSF_CERT}" "CST_CSF_CERT"
verify_env "${CST_IMG_CERT}" "CST_IMG_CERT"
verify_env "${CST_BIN}" "CST_BIN"
verify_env "${IMXBOOT}" "IMXBOOT"
verify_env "${LOG_MKIMAGE}" "LOG_MKIMAGE"
verify_env "${LOG_PRINT_FIT_HAB}" "LOG_PRINT_FIT_HAB"

readonly CSF_SPL="${TARGET}-csf-spl"
readonly CSF_FIT="${TARGET}-csf-fit"

cd ${DIR_SCRIPT}

generate_csf_spl
generate_csf_fit

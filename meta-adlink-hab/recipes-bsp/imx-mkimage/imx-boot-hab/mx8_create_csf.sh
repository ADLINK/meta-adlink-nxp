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
    echo "    CST_KEY                   Path to Public key certificate,   e.g. CSF1_1_sha256_4096_65537_v3_usr_crt.pem"
    echo "    CST_BIN                   Path to NXP CST Binary            e.g. cst-3.1.0/release/linux64/bin/cst"
    echo "    IMAGE                     Path to unsigned image"
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
    # if [ ! -f $1 ]; then
    #     help "Could not find '$1' $(pwd)"
    # fi
	echo "Verified $2=$1"
}

generate_csf_ahab() {
    CST_DIR=${CST_BIN%/*}
    IMAGE_CSF=${CST_DIR}/${TARGET}.csf

    # Copy template file
    cp ${DIR_SCRIPT}/mx8_template.csf ${IMAGE_CSF}

    # Get offset from log
    HEADER=$(cat ${LOG_MKIMAGE} | grep "CST: CONTAINER 0 offset:" | tail -1 | awk '{print $5}')
    BLOCK=$(cat ${LOG_MKIMAGE} | grep "CST: CONTAINER 0: Signature Block" | tail -1 | awk '{print $9}')

    # Update SRK files
    sed -i "s|CST_SRK|${CST_SRK}|g" ${IMAGE_CSF}
    sed -i "s|CST_KEY|${CST_KEY}|g" ${IMAGE_CSF}

    # Update offset
    sed -i "s|flash.bin|${IMAGE}|g" ${IMAGE_CSF}
    sed -i '/Offsets   = 0x400/d' ${IMAGE_CSF}
    echo "Offsets = ${HEADER} ${BLOCK}" >> ${IMAGE_CSF}

    # Sign
    ${CST_BIN} -i ${IMAGE_CSF} -o ${IMAGE}-signed
}

parse_args "$@"

# Print command for Yocto logs
echo $0 "$@"

# Verify required variables
if [ -z "${TARGET}" ]; then
    help "target argument required"
fi
verify_env "${CST_SRK}" "CST_SRK"
verify_env "${CST_KEY}" "CST_KEY"
verify_env "${CST_BIN}" "CST_BIN"
verify_env "${IMAGE}" "IMAGE"
verify_env "${LOG_MKIMAGE}" "LOG_MKIMAGE"

readonly CSF_SPL="${TARGET}-csf-spl"
readonly CSF_FIT="${TARGET}-csf-fit"

cd ${DIR_SCRIPT}

generate_csf_ahab

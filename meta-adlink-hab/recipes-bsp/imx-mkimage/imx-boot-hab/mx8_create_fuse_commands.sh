#!/bin/bash

set -e

readonly FILE_SCRIPT="$(basename "$0")"
readonly DIR_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly WARNING1="# Note: These are One-Time Programmable e-fuses. Once you write them you can't go back, so get it right the first time.
"
readonly WARNING2="
# After the device successfully boots a signed image without generating any HAB events, it is safe to secure, or 'close', the device.
# This is the last step in the process. Once the fuse is blown, the chip does not load an image that has not been signed using the correct PKI tree.
# Important notes:
# - This is again a One-Time Programmable e-fuse. Once you write it you can't go back, so get it right the first time.
# - If anything in the previous steps wasn't done correctly, the SOM will not boot after writing this bit.
"

help() {
    if [ -n "${1}" ]; then
        echo " Error: ${1}"
    fi
    echo
    echo " Usage: ${DIR_SCRIPT}/${FILE_SCRIPT} <mx8m|mx8x|mx8> <Path to SRK HASH> <output file>"
    echo
    echo " Example: ${DIR_SCRIPT}/${FILE_SCRIPT} SRK1_2_3_4_fuse.bin fuse.cmds"
    echo
    exit 1
}

fuse_write_line() {
    bank=$1
    word=$2
    value=$3
    echo "fuse prog -y $bank $word $value"
}

create_fuse_cmds_mx8m() {
    echo "${WARNING1}" > ${fuse_log}
    word=0
    bank=6
    for i in $(seq 0 7); do
        if [ "$i" -eq "4" ]; then
            bank=7
            word=0
        fi
        offset=$(echo "$i * 4" | bc)
        value=$(hexdump -s $offset -n 4  -e '/4 "0x"' -e '/4 "%X""\n"' ${cst_srk_fuse})
        fuse_write_line $bank $word $value >> ${fuse_log}
        word="$(expr $word + 1)"
    done
    echo "${WARNING2}" >> ${fuse_log}
    echo "fuse prog 1 3 0x02000000" >> ${fuse_log}
}

create_fuse_cmds_mx8() {
    echo "${WARNING1}" > ${fuse_log}
    word="$1"
    bank=0
    for i in $(seq 0 15); do
        offset=$(echo "$i * 4" | bc)
        value=$(hexdump -s $offset -n 4  -e '/4 "0x"' -e '/4 "%X""\n"' ${cst_srk_fuse})
        fuse_write_line 0 $word $value >> ${fuse_log}
        word="$(expr $word + 1)"
    done
    echo "${WARNING2}" >> ${fuse_log}
    echo "ahab_close" >> ${fuse_log}
}

if [ "$#" -ne 3 ]; then
    help
fi
soc="$1"
cst_srk_fuse="$2"
fuse_log="$3"
if [ ! -f $cst_srk_fuse ]; then
    help "Could not find '$cst_srk_fuse'"
fi

case ${soc} in
  mx8m)
    create_fuse_cmds_mx8m
    ;;
  mx8x)
    create_fuse_cmds_mx8 730
    ;;
  mx8)
    create_fuse_cmds_mx8 722
    ;;
  *)
    help "Unsupported SOC $1"
    ;;
esac

#!/bin/bash
##########################
# Author: Po Cheng       #
# Date: 18/Dec/2023      #
##########################

MAC1=${1:-'-h'}
MAC2=${2:-''}
SOC=''
FUSE=''
BANK=9
WORD=0
OFFSET=0	# seek/offset = (bank * 4) + word, for imx8mp: bank = 9, word = 0, 1, 2

usage () {
  echo "syntax: fuse-mac.sh [-h] <MAC> [MAC2]"
}

find_fuse () {
  SOC=$(cat /sys/firmware/devicetree/base/compatible | xargs --null | awk '{print $1}')

  case $SOC in
  *imx6*)
    ;;
  *imx7*)
    ;;
  *imx8*)
    if [ -e /sys/bus/nvmem/devices/imx-ocotp0/nvmem ]; then
      FUSE=/sys/bus/nvmem/devices/imx-ocotp0/nvmem
      BANK=9
      WORD=0
    fi
    ;;
  esac

  if [ -z $FUSE ]; then
    echo "Could not find fuse file"
    exit 1
  fi
}

calc_offset () {
  case $SOC in
  *imx6*)
    ;;
  *imx7*)
    ;;
  *imx8*)
	OFFSET=$((($BANK*4)+$WORD))
	;;
  esac
}

check_mac () {
  if [ "$MAC1" = "-h" ]; then
    usage
    exit 0
  elif [ ! $(echo -n $MAC1 | grep "^[[:xdigit:]]\{12\}$") ]; then
    # MAC1
    echo "MAC1 address must be 12 characters of hexadecimal digits"
    usage
    if [ -n $MAC2 -a ! $(echo -n $MAC2 | grep "^[[:xdigit:]]\{12\}$") ]; then
      # MAC2
      usage
      echo "MAC2 address must be 12 characters of hexadecimal digits"
    fi
    exit 1
  fi
}

burn_mac () {
  # fuse the mac address, little endian, e.g. for value of 0x12345678
  # printf '\x78\x56\x34\x12' | dd of=/sys/bus/nvmem/devices/imx-ocotp0/nvmem bs=4 count=1 seek=37 conv=notrunc
  if [ "$MAC1" != "" ]; then
    echo "fusing mac address 1: ${MAC1}"
    printf "$(printf '\\x%s\\x%s\\x%s\\x%s' ${MAC1:10:2} ${MAC1:8:2} ${MAC1:6:2} ${MAC1:4:2})" | dd of=$FUSE bs=4 count=1 seek=$OFFSET conv=notrunc
    if [ "$MAC2" = "" ]; then
      printf "$(printf '\\x%s\\x%s\\x00\\x00' ${MAC1:2:2} ${MAC1:0:2})" | dd of=$FUSE bs=4 count=1 seek=$(($OFFSET+1)) conv=notrunc
    fi
    if [ "$MAC2" != "" ]; then
      echo "fusing mac address 2: ${MAC2}"
      printf "$(printf '\\x%s\\x%s\\x%s\\x%s' ${MAC1:2:2} ${MAC1:0:2} ${MAC2:10:2} ${MAC2:8:2})" | dd of=$FUSE bs=4 count=1 seek=$(($OFFSET+1)) conv=notrunc
      printf "$(printf '\\x%s\\x%s\\x%s\\x%s' ${MAC2:6:2} ${MAC2:4:2} ${MAC2:2:2} ${MAC2:0:2})" | dd of=$FUSE bs=4 count=1 seek=$(($OFFSET+2)) conv=notrunc
    fi
  fi
  sync
}

# --- main ---
if [ $# -lt 0 -o $# -gt 2 ]; then
  usage
  exit 1
fi

check_mac
find_fuse
calc_offset
burn_mac


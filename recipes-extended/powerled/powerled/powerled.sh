#!/bin/bash
##########################
# Author: Po Cheng       #
# Date: 24/06/2021       #
##########################

if [ $# -gt 0 -a $# -le 5 ]; then
  echo "syntax: powerled.sh <I2C_BUS> <I2C_ADDR> <REG_DIR> <REG_DATA> <REG_DATA_MASK>"
  exit 1
fi

I2C_BUS=${1:-4}
I2C_ADDR=${2:-0x70}
REG_DIR=${3:-0x0f}
REG_DATA=${4:-0x11}
REG_DATA_MASK=${5:-0x20}

# direction on ioexpander
DIRECTION=$( i2cget -f -y $I2C_BUS $I2C_ADDR $REG_DIR )
# from 3f => 1f
DIRECTION=$(( $DIRECTION & ( ~ $REG_DATA_MASK ) ))
i2cset -f -y $I2C_BUS $I2C_ADDR $REG_DIR $DIRECTION

# value on iopexpander
VALUE=$( i2cget -f -y $I2C_BUS $I2C_ADDR $REG_DATA )
# from cf => ef
VALUE=$(( $VALUE | $REG_DATA_MASK ))
i2cset -f -y $I2C_BUS $I2C_ADDR $REG_DATA $VALUE

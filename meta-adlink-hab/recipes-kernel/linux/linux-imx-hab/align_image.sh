#!/bin/bash

IMAGE_SIZE=`wc -c < $1`
ALIGNED_SIZE=$(( ($IMAGE_SIZE + 0x1000 - 1) & ~ (0x1000 - 1) ))

printf "Extend $1 from 0x%x to 0x%x...\n" $IMAGE_SIZE $ALIGNED_SIZE
objcopy -I binary -O binary --pad-to $ALIGNED_SIZE --gap-fill=0x00 $1 ${1}-pad

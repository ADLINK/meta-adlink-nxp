#!/bin/sh

# Extract root device and slot from /proc/cmdline
rootpart=$(grep -o 'root=/dev/mmcblk[0-9]*p[0-9]*' /proc/cmdline | cut -d= -f2)
rootdev=$(echo "$rootpart" | sed 's/p[0-9]*$//')
slot=$(grep -o 'rauc.slot=[AB]' /proc/cmdline | cut -d= -f2)

# Fallbacks
[ -z "$rootdev" ] && rootdev="/dev/mmcblk1"
[ -z "$slot" ] && slot="A"

# Set env offset/size for fw_env.config
ENV_OFFSET=0x400000
ENV_SIZE=0x4000
echo "${rootdev} ${ENV_OFFSET} ${ENV_SIZE}" > /etc/fw_env.config

# Link correct RAUC system.conf
if [ "$rootdev" = "/dev/mmcblk2" ]; then
    ln -sf /etc/rauc/system_emmc.conf /etc/rauc/system.conf
else
    ln -sf /etc/rauc/system_sd.conf /etc/rauc/system.conf
fi

# -------------------------------------------------
# Hardcoded slot partition allow-list
# -------------------------------------------------
# Adjust these to your layout
# Set partition allow-lists based on detected root device
if echo "$rootdev" | grep -q "mmcblk1"; then
    SLOT_A_PARTS="/dev/mmcblk1p1 /dev/mmcblk1p2"
    SLOT_B_PARTS="/dev/mmcblk1p3 /dev/mmcblk1p4"
elif echo "$rootdev" | grep -q "mmcblk2"; then
    SLOT_A_PARTS="/dev/mmcblk2p1 /dev/mmcblk2p2"
    SLOT_B_PARTS="/dev/mmcblk2p3 /dev/mmcblk2p4"
else
    echo "Unknown root device, defaulting to mmcblk1 partitions"
    SLOT_A_PARTS="/dev/mmcblk1p1 /dev/mmcblk1p2"
    SLOT_B_PARTS="/dev/mmcblk1p3 /dev/mmcblk1p4"
fi

if [ "$slot" = "A" ]; then
    allowed="$SLOT_A_PARTS"
else
    allowed="$SLOT_B_PARTS"
fi

# -------------------------------------------------
# Unmount partitions on same disk except allowed
# -------------------------------------------------
for part in $(lsblk -ln -o NAME "/dev/$(basename "$rootdev")" | grep -E 'p[0-9]+$'); do
    fullpath="/dev/$part"
    if ! echo "$allowed" | grep -qw "$fullpath"; then
        if mount | grep -q "$fullpath"; then
            echo "Unmounting $fullpath..."
            umount -f "$fullpath"
        fi
    fi
done

#make sure rauc service is restarted
systemctl restart rauc.service

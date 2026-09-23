# LEC-iMX95 OSTree boot script.
#
# Run by U-Boot standard boot (CONFIG_BOOTMETH_SCRIPT), which scans bootable
# partitions for boot.scr.uimg and sets devtype, devnum and distro_bootpart
# beforehand. Use devtype/devnum, not mmcdev: mmcdev is only set later by
# bsp_bootcmd and can point at the wrong device when booting from SD.
#
# OSTree rewrites /boot/loader/uEnv.txt on every deployment, supplying
# kernel_image, ramdisk_image, fdt_file and bootargs for the current one.

# p1 = vfat boot, p2 = ext4 otaroot, per lec-imx95-ostree.wks.in
setenv ostree_part 2

echo "OSTree: reading uEnv.txt from ${devtype} ${devnum}:${ostree_part}"
if ext4load ${devtype} ${devnum}:${ostree_part} ${scriptaddr} /boot/loader/uEnv.txt; then
	env import -t ${scriptaddr} ${filesize}
else
	echo "OSTree: no uEnv.txt - falling back to BSP boot"
	exit
fi

# Automatic rollback: U-Boot ran altbootcmd because the boot counter exceeded
# bootlimit, which set ostree_rollback=1. Swap in the second deployment's
# variables so we boot the previous, known-good deployment instead.
if test "${ostree_rollback}" = "1"; then
	if test -n "${kernel_image2}"; then
		echo "OSTree: BOOT LIMIT EXCEEDED - booting ROLLBACK deployment"
		setenv kernel_image ${kernel_image2}
		setenv ramdisk_image ${ramdisk_image2}
		setenv fdt_file ${fdt_file2}
		setenv bootargs ${bootargs2}
	else
		echo "OSTree: rollback requested but no second deployment available"
	fi
fi

if test -z "${kernel_image}"; then
	echo "OSTree: uEnv.txt has no kernel_image - falling back to BSP boot"
	exit
fi

echo "OSTree: kernel ${kernel_image}"
echo "OSTree: initrd ${ramdisk_image}"
echo "OSTree: fdt    ${fdt_file}"

ext4load ${devtype} ${devnum}:${ostree_part} ${loadaddr} ${kernel_image}

# Capture the initrd size immediately - any later load overwrites ${filesize}.
ext4load ${devtype} ${devnum}:${ostree_part} ${initrd_addr} ${ramdisk_image}
setenv initrd_size ${filesize}

ext4load ${devtype} ${devnum}:${ostree_part} ${fdt_addr_r} ${fdt_file}

# OSTree's bootargs already carry console= and root=LABEL=otaroot; only prepend
# the i.MX-specific clock and mcore arguments.
setenv bootargs ${jh_clk} ${mcore_args} ${bootargs}

echo "OSTree: booting"
booti ${loadaddr} ${initrd_addr}:${initrd_size} ${fdt_addr_r}

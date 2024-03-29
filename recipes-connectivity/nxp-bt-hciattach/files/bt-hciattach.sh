#!/bin/bash

HCILIST=
RESET_CTLR=

initial_attach() {
	killall hciattach
	/usr/bin/hciattach /dev/ttymxc0 any 115200 flow
	sleep 5
	if [ $? -eq 0 ]; then
		HCILIST=$(hciconfig | grep -o hci[0-9] | tr '\n' ' ' 1>/dev/null)
	else
		exit -19
	fi
}

check_marvell() {
	for ctlr in $HCILIST; do
		VENDOR=$(hciconfig $ctlr version | grep -q -i "Manufacturer")
		case "$VENDOR" in
			*Marvell*) RESET_CTLR=$ctlr ;;
			*72*) RESET_CTLR=$ctlr ;;
		esac
	done
}

reset_attach() {
	hciconfig $RESET_CTLR up
	hcitool -i $RESET_CTLR cmd 0x3f 0x0009 0xc0 0xc6 0x2d 0x00
	killall hciattach
	/usr/bin/hciattach /dev/ttymxc0 any 3000000 flow
	sleep 5
	hciconfig $RESET_CTLR up
}

# ===== main =====
initial_attach
check_marvell
if [ -n $RESET_CTLR ]; then
	reset_attach
fi


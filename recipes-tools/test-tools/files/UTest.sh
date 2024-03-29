#! /bin/sh

export PATH=.:$PATH

OTG_PATH="/sys/kernel/debug/38100000.dwc3/mode"
PROG="USBTest"
BUS=""
DEVICE=""
PORT=""
MODE=""

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

usage () {
	echo "USB 2.0 Eye Diagram Test for LEC-iMX8M Plus A1 + IPi SMARC Plus A1"
	echo "$1 Port[1-7] Test_Mode[0-4]"
	echo "Port:"
	echo "1 : test CN601 Top"
	echo "2 : test CN601 Buttom               (CN1602 38-40)"
	echo "3 : test CN2301 M.2 B Key Connector (CN1602 36-38)"
	echo "4 : test CN702 Top"
	echo "5 : test U1702 Buttom"
	echo "6 : test CN2401 M.2 E Key Connector"
	echo "7 : test CN701 USB 2.0 OTG Connector"
	echo "Test_Mode:"
	echo "0 : disable"
	echo "1 : test_j"
	echo "2 : test_k"
	echo "3 : test_se0_nak"
	echo "4 : test_packet"
	exit;
}

if [ $# != 2 ]; then
	echo "Error command"
	usage $0
fi

if [ "$1" = "1" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="003"
else
	BUS="001"
fi
	DEVICE="002"
	PORT="2"
elif [ "$1" = "2" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="003"
else
	BUS="001"
fi
	DEVICE="002"
        PORT="1"
elif [ "$1" = "3" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="003"
else
	BUS="001"
fi
	DEVICE="002"
	PORT="1"
elif [ "$1" = "4" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="003"
else
	BUS="001"
fi
	DEVICE="002"
	PORT="5"
elif [ "$1" = "5" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="003"
else
	BUS="001"
fi
	DEVICE="002"
	PORT="6"
elif [ "$1" = "6" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="003"
else
	BUS="001"
fi
	DEVICE="002"
	PORT="3"
elif [ "$1" = "7" ]; then
if [[ -f "$OTG_PATH" ]]; then
	BUS="001"
	DEVICE="001"
	PORT="1"
else
	echo "Not available!! Please update Device Tree blob."
	exit
fi
else
	usage $0
fi

if [ "$2" = "1" ]; then
	MODE="1"
elif [ "$2" = "2" ]; then
	MODE="2"
elif [ "$2" = "3" ]; then
	MODE="3"
elif [ "$2" = "4" ]; then
	MODE="4"
elif [ "$2" = "0" ]; then
	MODE="0"
else
	usage $0
fi

$PROG /dev/bus/usb/$BUS/$DEVICE $PORT $MODE &


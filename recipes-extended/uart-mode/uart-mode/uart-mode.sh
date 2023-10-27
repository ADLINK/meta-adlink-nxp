#!/bin/bash
##########################
# Author: Po Cheng       #
# Date: 27/10/2023       #
##########################

usage () {
	echo "syntax: uart-mode.sh <mode> [gpio num] [mode0 pin] [mode1 pin]"
	echo "      mode: loopback, rs232, rs485, rs422"
	echo "  gpio num: 0 to 4"
	echo " mode0 pin: 0 to 31"
	echo " mode1 pin: 0 to 31"
	echo " Note: mode0 and mode1 pins are different, but on same gpio controller"
}

if ! [ $# -ge 0 -a $# -le 4 ]; then
	usage
	exit 1
elif [ "$1" = "-h" -o "$1" = '--help' ]; then
	usage
	exit 0
fi

UART_MODE=${1:-rs232}    # default to rs232
GPIO_NUM=${2:-3}         # default to gpio3
MODE0_PIN=${3:-24}       # default to pin24
MODE1_PIN=${4:-25}       # default to pin25

if [ $# -eq 0 ]; then
	echo "Using default: uart mode = $UART_MODE, gpio controller = $GPIO_NUM, mode0_pin = $MODE0_PIN, mode1_pin = $MODE1_PIN"
fi

if [[ $GPIO_NUM -ge 0 && $GPIO_NUM -le 4 ]] && \
   [[ $MODE0_PIN -ge 0 && $MODE0_PIN -le 31 ]] && \
   [[ $MODE1_PIN -ge 0 && $MODE1_PIN -le 31 ]] && \
   [[ $MODE0_PIN -ne $MODE1_PIN ]]; then
	#check for root
	BEROOT=""
	if [ $(id -u) -ne 0 ];then
	    BEROOT=sudo
	fi
	case "${UART_MODE}" in
		"loopback")
			$BEROOT gpioset $GPIO_NUM $MODE0_PIN=0;
			$BEROOT gpioset $GPIO_NUM $MODE1_PIN=0;
			;;
		"rs485")
			$BEROOT gpioset $GPIO_NUM $MODE0_PIN=0;
			$BEROOT gpioset $GPIO_NUM $MODE1_PIN=1;
			;;
		"rs422")
			$BEROOT gpioset $GPIO_NUM $MODE0_PIN=1;
			$BEROOT gpioset $GPIO_NUM $MODE1_PIN=1;
			;;
		"rs232")
			$BEROOT gpioset $GPIO_NUM $MODE0_PIN=1;
			$BEROOT gpioset $GPIO_NUM $MODE1_PIN=0;
			;;
		*)
			usage
			exit 1
			;;
	esac;
else
	usage
	exit 1
fi

exit 0


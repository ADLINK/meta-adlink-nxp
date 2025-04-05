#!/bin/sh
### BEGIN INIT INFO
# Provides:          restUartCfg
# Required-Start:    
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Restore UART port mode setting
# Description:       This script restore uart mode config
### END INIT INFO
sleep 8
if [ -d /sys/class/gpio_switch ]; then
    /usr/bin/uartCfg_restore
fi

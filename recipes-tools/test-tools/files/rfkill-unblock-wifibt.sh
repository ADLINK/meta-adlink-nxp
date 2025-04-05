#!/bin/sh
### BEGIN INIT INFO
# Provides:          unblock wifi-bt
# Required-Start:    
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: unblock wifi-bt interface at boot
# Description:       This script unblock wifi & bt interface at boot time
### END INIT INFO
sleep 3
/usr/sbin/rfkill unblock all

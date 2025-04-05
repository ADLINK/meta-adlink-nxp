#!/bin/sh
### BEGIN INIT INFO
# Provides:          tlv320init.sh
# Required-Start:    
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Initial alsa config parameters
# Description:       This script initial codec driver register
### END INIT INFO
alsactl restore -f /etc/alsa.cfg
alsactl store -f /var/lib/alsa/asound.state
sync

#!/bin/bash
iface=$1
ptp=
sec=
now=
if [ $iface == "eth0" ]; then
    ptp=ptp0
else
    ptp=ptp1
fi
ip link set $iface up
sec=$(tsntool ptptool -g -d /dev/$ptp | awk '/ptp time:/ { print $3; }' | awk -F. '{ print $1; }')
echo "sec: ${sec}"
basetime=$(( ($sec + 1) * 1000000000 ))
echo "basetime: $basetime"
tc qdisc replace dev $iface parent root handle 100 taprio \
num_tc 5 map 0 1 2 3 4 queues 1@0 1@1 1@2 1@3 1@4 \
base-time $basetime \
sched-entry S 3 100000 \
sched-entry S 5 20000 \
sched-entry S 1 9880000 \
flags 2


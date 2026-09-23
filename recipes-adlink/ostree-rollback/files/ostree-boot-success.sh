#!/bin/sh
#
# Tell U-Boot whether this OSTree deployment is healthy.
#
# BOOTCOUNT_ENV increments "bootcount" on every boot while "upgrade_available"
# is 1. Once it exceeds bootlimit U-Boot runs altbootcmd, booting the previous
# deployment instead.
#
# Healthy boot -> clear both variables, disarming the counter.
# Failed boot  -> leave them and reboot, so the counter advances.
#
# The health check is an optional hook; if it is absent, reaching
# multi-user.target counts as healthy.

set -u
HOOK=/usr/bin/ostree-health-check
log() { echo "ostree-boot-success: $*"; }

if [ ! -r /etc/fw_env.config ]; then
    log "no /etc/fw_env.config, nothing to do"
    exit 0
fi

if [ -x "$HOOK" ]; then
    if "$HOOK"; then
        log "health check passed"
    else
        log "HEALTH CHECK FAILED - rebooting so U-Boot can count this failure"
        log "bootcount is now $(fw_printenv -n bootcount 2>/dev/null || echo unknown)"
        sleep 10
        systemctl --force reboot
        exit 1
    fi
else
    log "no health check hook, treating multi-user.target as healthy"
fi

# Deployment 0 is the default. Anything else means U-Boot rolled back; promote
# it so the next reboot does not retry the deployment that failed.
index=$(ostree admin status 2>/dev/null | awk 'BEGIN{n=0} /^[ *] [a-z]/{ if($1=="*"){print n; exit} n++ }')

if [ -n "$index" ] && [ "$index" != "0" ]; then
    log "booted rollback deployment $index, promoting it to default"
    ostree admin set-default "$index" || log "set-default failed"
fi

# libubootenv's fw_setenv -s requires key=value lines; the "key value" form
# silently sets an empty value and still exits 0.
TMP=$(mktemp)
printf 'bootcount=0\nupgrade_available=0\n' > "$TMP"
if fw_setenv -s "$TMP"; then
    log "boot confirmed, rollback counter disarmed"
else
    log "WARNING: fw_setenv failed, U-Boot environment not updated"
fi
rm -f "$TMP"

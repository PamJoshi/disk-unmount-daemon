#!/bin/bash
LOGFILE="/var/log/safe-unmount.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
    # Keep only last 10 lines
    tmpfile=$(mktemp)
    tail -n 10 "$LOGFILE" > "$tmpfile"
    mv "$tmpfile" "$LOGFILE"
}

unmount_drive() {
    local dev="$1"
    local mountpoint
    mountpoint=$(findmnt -nr -o TARGET "$dev")

    if [ -n "$mountpoint" ]; then
        log "Unmounting $dev mounted at $mountpoint"
        if umount -f "$mountpoint"; then
            log "Successfully unmounted $dev"
        else
            log "Failed to unmount $dev"
        fi
    else
        log "$dev not mounted"
    fi
}

# Drives to unmount (universal)
unmount_drive ""
unmount_drive ""
.
.
.
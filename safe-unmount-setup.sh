#!/bin/bash

SCRIPT="/home/param/Desktop/disk-unmount-daemon/safe-unmount.sh"
MARKER="# ADD_MORE_DRIVES_HERE"

# Must be run as sudo
if [[ $EUID -ne 0 ]]; then
    echo "Run using: sudo ./safe-unmount-setup.sh"
    exit
fi

echo "=== Available Partitions ==="
mapfile -t PARTS < <(lsblk -nrpo NAME,SIZE,TYPE,MOUNTPOINT | grep part)

# Show numbered list
for i in "${!PARTS[@]}"; do
    echo "$((i+1))) ${PARTS[$i]}"
done

echo
read -p "Enter numbers or partition paths: " -a input

for item in "${input[@]}"; do
    # Convert number → actual partition info line
    if [[ $item =~ ^[0-9]+$ ]]; then
        line="${PARTS[$item-1]}"
        dev=$(echo "$line" | awk '{print $1}')
    else
        dev="$item"
    fi

    # Prevent duplicates
    if grep -q "$dev" "$SCRIPT"; then
        echo "⚠ $dev already exists — skipping"
    else
        sed -i "/$MARKER/a unmount_drive \"$dev\"" "$SCRIPT"
        echo "✔ Added $dev"
    fi
done

echo -e "\nDone. Updated drive list:"
grep 'unmount_drive' "$SCRIPT"

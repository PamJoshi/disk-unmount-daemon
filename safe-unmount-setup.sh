#!/bin/bash

SCRIPT="/usr/local/bin/safe-unmount.sh"
MARKER="# ADD_MORE_DRIVES_HERE"

echo "=== Available Partitions ==="
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep part

read -p "Enter partitions to unmount (space-separated): " -a drives

for drive in "${drives[@]}"; do
    if grep -q "$drive" "$SCRIPT"; then
        echo "⚠ $drive already exists, skipping"
    else
        sudo sed -i "/$MARKER/a unmount_drive \"$drive\"" "$SCRIPT"
        echo "✔ Added $drive"
    fi
done

echo "Done. Updated list:"
grep 'unmount_drive' "$SCRIPT"

    #!/bin/bash

    SCRIPT="./safe-unmount.sh"
    SERVICE="./safe-unmount.service"
    MARKER="# ADD_MORE_DRIVES_HERE"

    # Ensure install marker exists in script
    grep -q "$MARKER" "$SCRIPT" || echo "$MARKER" >> "$SCRIPT"

    # Must be run as root
    if [[ $EUID -ne 0 ]]; then
        echo "Run using: sudo ./safe-unmount-setup.sh"
        exit
    fi

    menu() {
        clear
        echo "================ Disk Auto-Unmount Setup ================"
        echo "1) Fresh Install (clean previous drives & add new)"
        echo "2) Add Partitions (keep existing)"
        echo "3) View Configured Drives"
        echo "4) Reset (remove all unmount_drive entries)"
        echo "5) Hard Reset (remove service & script)"
        echo "6) Exit"
        echo "========================================================="
        read -p "Choose option (1-6): " choice
    }

    show_partitions() {
        echo -e "\n=== Available Partitions ==="
        mapfile -t PARTS < <(lsblk -nrpo NAME,SIZE,TYPE,MOUNTPOINT | awk '$3=="part"{print $1" "$2" "$4}')

        [[ ${#PARTS[@]} -eq 0 ]] && { echo "No partitions found"; return; }

        for i in "${!PARTS[@]}"; do
            echo "$((i+1))) ${PARTS[$i]}"
        done
        echo
    }

    add_drives() {
        show_partitions
        read -p "Enter numbers or device paths (space separated): " -a input

        for item in "${input[@]}"; do
            if [[ $item =~ ^[0-9]+$ ]]; then
                dev=$(echo "${PARTS[$item-1]}" | awk '{print $1}')
            else
                dev="$item"
            fi

            if grep -q "unmount_drive \"$dev\"" "$SCRIPT"; then
                echo "⚠ $dev already exists — skipping"
            else
                sed -i "/$MARKER/a unmount_drive \"$dev\"" "$SCRIPT"
                echo "✔ Added $dev"
            fi
        done

        echo -e "\nUpdated entries:"
        grep 'unmount_drive' "$SCRIPT" || echo "No drives configured"
    }

    fresh_install(){
        echo "⚠ This will remove all previously added drives!"
        read -p "Continue? (y/n): " confirm
        [[ $confirm != "y" ]] && { echo "Cancelled."; return; }

        # Remove only appended drive entries, keep function safe
        sed -i "/$MARKER/,\$ { /unmount_drive/d }" "$SCRIPT"

        add_drives

        echo -e "\n📦 Installing script and service..."
        # Copy script
        cp "$SCRIPT" /usr/local/bin/safe-unmount.sh
        chmod +x /usr/local/bin/safe-unmount.sh
        echo "✔ Script installed to /usr/local/bin/"

        # Copy service
        cp "$SERVICE" /etc/systemd/system/safe-unmount.service
        echo "✔ Service installed to /etc/systemd/system/"

        # Reload systemd and enable
        systemctl daemon-reload
        systemctl enable safe-unmount.service
        echo "✔ Service enabled and ready"
    }


    view_configured() {
        echo -e "\n=== Configured Drives ==="
        entries=$(grep 'unmount_drive' "$SCRIPT")

        if [[ -z "$entries" ]]; then
            echo "No drives configured"
        else
            echo "$entries" | sed 's/unmount_drive "//; s/"//'
        fi
        echo
        read -p "Press Enter..."
    }

    reset_drives(){
        echo "⚠ Remove all configured drives?"
        read -p "Confirm (y/n): " confirm
        [[ $confirm != "y" ]] && return

        # Delete only lines AFTER marker, not function
        sed -i "/$MARKER/,\$ { /unmount_drive/d }" "$SCRIPT"

        echo "✔ All drive entries removed."
    }

    hard_reset(){
        SCRIPT="/usr/local/bin/safe-unmount.sh"
        SERVICE="/etc/systemd/system/safe-unmount.service"

        echo "⚠ This will completely remove the service and script!"
        read -p "Continue? (y/n): " confirm
        [[ $confirm != "y" ]] && { echo "Cancelled."; return; }

        # Disable service
        systemctl disable safe-unmount.service 2>/dev/null
        systemctl stop safe-unmount.service 2>/dev/null
        echo "✔ Service disabled"

        # Remove files
        [[ -f "$SCRIPT" ]] && rm -f "$SCRIPT" && echo "✔ Script removed from /usr/local/bin/"
        [[ -f "$SERVICE" ]] && rm -f "$SERVICE" && echo "✔ Service file removed from /etc/systemd/system/"

        # Reload systemd
        systemctl daemon-reload
        echo "✔ Hard reset completed"
    }


    # Main loop
    while true; do
        menu
        case $choice in
            1) fresh_install ;;
            2) add_drives ;;
            3) view_configured ;;
            4) reset_drives ;;
            5) hard_reset ;;
            6) echo "Bye!"; exit ;;
            *) echo "Invalid choice"; sleep 1 ;;
        esac
    done

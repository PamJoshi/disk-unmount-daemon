# disk-unmount-daemon

**disk-unmount-daemon** is a simple universal systemd service + shell script that automatically unmounts selected disk partitions during system shutdown, reboot, or halt.  
It helps prevent filesystem corruption or bad sectors when a sudden power loss occurs while drives are actively in use.

The project works with **any filesystem** (ext4, NTFS, FAT32, exFAT, Btrfs, etc.) because it only unmounts the specified devices.

---

## Features

- Automatically unmounts selected drives before shutdown.
- Works on any filesystem / any OS partition.
- Logs every unmount attempt to `/var/log/unmount-windows-drives.log`.
- Log trimmed to last 10 entries to prevent large files.
- Uses `umount -f` to ensure drive is released safely.
- Minimal, reliable, and easy to customize.

---

## Repository Contents

### **1. disk-unmount-daemon.service**



### **2. unmount-windows-drives.sh**

---

## Installation

### 1. Copy the script
```
sudo cp unmount-windows-drives.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/unmount-windows-drives.sh
```

### 2. Copy the service file
```
sudo cp disk-unmount-daemon.service /etc/systemd/system/
```

### 3. Reload systemd
```
sudo systemctl daemon-reload
```

### 4. Enable the service
```
sudo systemctl enable disk-unmount-daemon.service
```

### 5. (Optional) Test the script
```
sudo /usr/local/bin/unmount-windows-drives.sh
```

---

## Customization

To add or remove drives, edit the bottom of the script:

```bash
unmount_drive "/dev/sdb1"
unmount_drive "/dev/nvme0n1p2"
unmount_drive "/dev/sdc3"
```

List your partitions with:

```
lsblk -f
```

---

## Log File Location

Logs are stored at:

```
/var/log/unmount-windows-drives.log
```

Only last **10 lines** are kept automatically.

---

## License

This project uses the license included in this repository.

---

## Contributing

Open for pull requests — improvements and universal compatibility ideas are welcome.


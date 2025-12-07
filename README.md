<div align="center">

# 🔌 disk-unmount-daemon
### Safe automatic disk unmounting service for Linux

[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE) 
[![Platform](https://img.shields.io/badge/Platform-Linux-blue)](https://www.linux.org/) 
[![systemd Service](https://img.shields.io/badge/Systemd-Service-orange)]()

</div>

---

## 🚀 Overview

**disk-unmount-daemon** is a **universal systemd service + shell script** that automatically unmounts selected disk partitions before shutdown, reboot, or halt.  

It prevents:

- ❌ Filesystem corruption  
- ❌ Bad sectors  
- ❌ Lost data during power cuts  

Works with **any filesystem**: ext4, NTFS, FAT32, exFAT, Btrfs, etc.

---

## ✨ Features

- 🛡 Automatically unmounts drives before shutdown  
- 🔄 Works on any filesystem / OS partition  
- 📄 Logs all unmount attempts to `/var/log/unmount-windows-drives.log`  
- 🧹 Log trimmed to last 10 entries  
- ⚡ Forces unmount with `umount -f`  
- 🔧 Minimal, reliable, and easy to customize  

---

## 🗂 Repository Contents

| File | Description |
|------|------------|
| `disk-unmount-daemon.service` | systemd service file for auto-unmount |
| `unmount-windows-drives.sh` | Script to unmount drives and log actions |

---

## 🛠 Installation

### 1️⃣ Copy the script
```bash
sudo cp safe-unmount.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/safe-unmount.sh
```

### 2️⃣ Copy the service file
```bash
sudo cp safe-unmount.service /etc/systemd/system/
```

### 3️⃣ Reload systemd
```bash
sudo systemctl daemon-reload
```

### 4️⃣ Enable the service
```bash
sudo systemctl enable safe-unmount.service.service
```

### 5️⃣ Optional — Test manually
```bash
sudo /usr/local/bin/safe-unmount.service.sh
```

---

## ⚙ Customization

Edit the script to add or remove drives:

```bash
unmount_drive "/dev/sdb1"
unmount_drive "/dev/nvme0n1p2"
unmount_drive "/dev/sdc3"
```

Check all partitions with:

```bash
lsblk -f
```

---

## 📄 Log File

Logs stored at:

```
/var/log/unmount-windows-drives.log
```

Only the last **10 lines** are kept automatically.

---

## 📝 License

MIT License — see [LICENSE](LICENSE) file.

---

## 🤝 Contributing

Contributions welcome!  
Pull requests for **new features, bug fixes, or cross-filesystem improvements** are encouraged.

---

<div align="center">

```
     _ _     _                                                 _            _                                  
  __| (_)___| | __     _   _ _ __  _ __ ___   ___  _   _ _ __ | |_       __| | __ _  ___ _ __ ___   ___  _ __  
 / _` | / __| |/ /____| | | | '_ \| '_ ` _ \ / _ \| | | | '_ \| __|____ / _` |/ _` |/ _ \ '_ ` _ \ / _ \| '_ \ 
| (_| | \__ \   <_____| |_| | | | | | | | | | (_) | |_| | | | | ||_____| (_| | (_| |  __/ | | | | | (_) | | | |
 \__,_|_|___/_|\_\     \__,_|_| |_|_| |_| |_|\___/ \__,_|_| |_|\__|     \__,_|\__,_|\___|_| |_| |_|\___/|_| |_|
                                                                                                               
```

</div>

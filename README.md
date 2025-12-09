<div align="center">

# 🔌 disk-unmount-daemon
### Safe automatic disk unmounting service for Linux

[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE) 
[![Platform](https://img.shields.io/badge/Platform-Linux-blue)](https://www.linux.org/) 
[![systemd Service](https://img.shields.io/badge/Systemd-Service-orange)]()

</div>

---

## 🚀 Overview

**disk-unmount-daemon** is a **universal systemd service + shell script** that automatically stops ongoing processes and unmounts selected disk partitions before shutdown, reboot, or halt.  

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
| `safe-unmount.sh` | Script to unmount drives and log actions |
| `safe-unmount.service` | systemd service for auto-unmount |
| `safe-unmount-setup.sh` | Optional interactive setup installer |

---

## 🛠 Installation

### 1️⃣ Copy script & service

```bash
sudo cp safe-unmount.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/safe-unmount.sh

sudo cp safe-unmount.service /etc/systemd/system/
```

<div align="center">

```
     _ _     _                                                 _            _                                  
  __| (_)___| | __     _   _ _ __  _ __ ___   ___  _   _ _ __ | |_       __| | __ _  ___ _ __ ___   ___  _ __  
 / _` | / __| |/ /____| | | | '_ \| '_ ` _ \ / _ \| | | | '_ \| __|____ / _` |/ _` |/ _ \ '_ ` _ \ / _ \| '_ \ 
| (_| | \__ \   <_____| |_| | | | | | | | | | (_) | |_| | | | | ||_____| (_| | (_| |  __/ | | | | | (_) | | | |
 \__,_|_|___/_|\_\     \__,_|_| |_|_| |_| |_|\___/ \__,_|_| |_|\__|     \__,_|\__,_|\___|_| |_| |_|\___/|_| |_|
                                                                                                               
```

</div>

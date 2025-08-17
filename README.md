# 🚀 Warp_Bypass

![Warp Terminal](https://i0.wp.com/www.omgubuntu.co.uk/wp-content/uploads/2024/02/warp-ai-features.jpg) 
                             Image source: omgubuntu.co.uk
> **Warp_Bypass** is a lightweight script that installs and runs [Warp](https://www.warp.dev) terminal inside a secure, disposable environment — ensuring privacy, isolation, and reusability.

---

## ✨ Overview

[Warp](https://www.warp.dev) is a modern **Rust-based, GPU-accelerated terminal** built for speed and collaboration.  
This script automates Warp setup on Debian-based Linux systems (Kali, Ubuntu, Debian), providing:

✅ One-command Warp installation  
✅ Secure **temporary user** environment  
✅ Built-in **privacy hardening** (blocks telemetry domains)  
✅ Optional **MAC address randomization + DHCP renewal**  
✅ Automatic cleanup on exit  

---

## ⚡ Features

- 🔒 **Isolated execution**: Warp runs as a temporary user with passwordless sudo.  
- 🛑 **Telemetry blocking**: Automatically blackholes Warp’s tracking domains via `/etc/hosts`.  
- 🎭 **Network anonymity**: Optional MAC address randomization with `macchanger`.  
- 🌐 **Fresh IP lease**: Optional DHCP renewal (`dhclient`) for a clean network identity.  
- 🖥️ **X11 support**: Runs Warp seamlessly under X11 with proper permissions.  
- 🔄 **Usage limit reset**: Warp AI prompts capped at **50 per session** — just rerun the script to refresh.  

---

## 📦 Requirements

### ✅ Supported OS
- Debian-based Linux distros  
  - Kali Linux  
  - Ubuntu  
  - Debian  

⚠️ **X11 required** (Wayland not supported).  

### 🔧 Dependencies

| Package            | Purpose                            | Install Command                         |
|--------------------|------------------------------------|-----------------------------------------|
| `x11-xserver-utils`| X11 access control (`xhost`)       | `sudo apt install x11-xserver-utils`    |
| `macchanger`       | MAC address randomization          | `sudo apt install macchanger`           |
| `sudo`             | Run privileged commands            | Pre-installed on most distros           |
| `isc-dhcp-client`  | Optional DHCP renewal              | `sudo apt install isc-dhcp-client`      |

---

<img width="1920" height="1080" alt="Screenshot_2025-08-17_14_00_33" src="https://github.com/user-attachments/assets/c1fc09c1-198e-4e3a-8d39-2f8ef89d65e8" />


## 📂 Setup
0. Install [Warp.deb](https://www.warp.dev) file.
1. make sure  the Warp `.deb` file is in same directory of warp_bypass.sh.
2. install all pakeges above.
3. Run the bellow command:
   ```
   sudo chmod +x ./warp_bypass
   sudo ./warp_bypass
   ```
5. Make sure when you when starts it will show sign-in but you should click on skip for now 
---

## 📝 Note

This project is intended **only for privacy and automate setup**.  
Since **Warp Terminal limits AI requests to 50 per day**, this script automates the re-setup process so you don’t need to manually reinstall or configure it every time.  

After exceeding the 50-request limit, simply rerun the script to launch a **fresh Warp session** with everything set up automatically.

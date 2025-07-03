# Jellyfin media server + SMB file server on RaspberryPi over Meshnet

<p align="center">
<img src="https://img.shields.io/badge/NordVPN-FFFFFF?style=for-the-badge&logo=nordvpn&logoColor=4F81C7&labelColor=white" alt="NordVPN">
<img src="https://img.shields.io/badge/-Raspberry%20Pi-A22846?logo=raspberrypi" alt="Raspberry Pi">
<img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>


## 📌 Environment
- **Device**: Raspberry Pi 5
- **OS**: "Debian GNU/Linux 12 (bookworm)"
- **VPN**: Nord VPN Meshnet
- **Media server**: Jellyfin
- **Storage**: External HDD
- **File share**: SMB (Samba)

---

## 🔧 SMB Configuration

```
sudo smbpasswd -a username #it will prompt to setting up new password

```

```bash
sudo mkdir /mnt/drive
sudo blkid #Find UUID
```

To do smb configurations perfectly first need to find the UUID of the external HDD with blkid cmd then add it to fstab and add mount point of the HDD which created earlier and set formats correctly whether its ntfs or variants of exfat then id's.

```
UUID=XXXX-XXXX  /mnt/drive ntfs defaults, uid=1000, gid=1000 0 0
```

### 🔧 Samba config(/etc/samba/smb.conf):
```
comment = Raspberry Pi Media Share
   path = /mnt/mediadrive
   browseable = yes
   writeable = yes
   create mask = 0664
   directory mask = 0775
   public = yes
   guest ok = no
   valid users = [mention user name here]
   force user = [mention user main user here]
```

- **issues**: permission issues are usual however we can mitigate this with setting up with proper permission recursively for the drive.
- **Fix**: chown -R username:username /mnt/drive

## 🔧 Jellyfin Setup

```
sudo apt update
sudo apt install jellyfin -y
sudo systemctl enable jellyfin
```

- **Screenshot**:

## Failures 

- ***Problems***
  - ❌ Jellyfin not detecting HDD 
  - ❌ After detected site cant be reached error in browser.
  - ❌ in smb share access denied.

- ***Fix***
  - ✅ Make sure to mount /mnt/drive with sudo mount -a 
  - ✅ Allow port number for jellyfin in firewall(ufw) default port is 8096 we can change it if we want
  - ✅ Give recursive permission to mounted drive


##  ⚙️ Meshnet Setup


first need to install nordvpn and signup then login with the account and enable meshnet no need to subscribe meshnet is completly free of cost.

```bash
nordvpn login
nordvpn meshnet enable
nordvpn meshnet peer list | grep "This device" -A 2  #it will show the raspberrypi's meshnet IP
```

### 🔐 What is Meshnet?
NordVPN's Meshnet is a private encrypted network that lets you connect your devices directly—bypassing the public internet. It works like a virtual LAN (Local Area Network), allowing secure access to devices anywhere in the world as if they were on the same local network.

### 🔑 Key Features
- ✔ Device Linking – Connect up to 60 devices (10 per NordVPN account + 50 external invites)
- ✔ Encrypted Traffic – All data is secured with NordVPN’s encryption
- ✔ No Internet Required – Works even if the VPN is off
- ✔ Static IPs – Each device gets a fixed 100.x.x.x IP (no dynamic changes)
- ✔ Cross-Platform – Works on Windows, macOS, Linux, Android, and iOS

```
nordvpn set meshnet on/off
nordvpn meshnet peer list
nordvpn meshnet peer refresh
nordvpn status
nordvpn settings
```

- ***issues***: sometime while enabling meshnet and accidentally connect VPN with anylocation meshnet don't work also after disconnect nordlynx public address for meshnet will override the dns, However after troubleshooting longtime i found out this so i wrote seperate script for dns fix.

- both the raspberry and tab or laptop need to be connected on same nordvpn account and meshnet enabled (different account also work but need some setup from invite send and recieve)

## Tip 
- By using CX file explorer we can access smb share in android 

## 📜 License
**MIT © [Naveen Bose]**
<p align="left">
<img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

#!/bin/bash
# Get the primary active connection (excluding lo and VPNs)
NEW_CONN=$(nmcli -t -f DEVICE,NAME con show --active | grep -vE 'lo|nordlynx' | head -n 1 | cut -d':' -f2)

if [ -z "$NEW_CONN" ]; then
    echo "Error: No suitable active connection found!"
    exit 1
fi

echo "Configuring DNS for connection: $NEW_CONN"
sudo nmcli con mod "$NEW_CONN" ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli con mod "$NEW_CONN" ipv4.ignore-auto-dns yes
sudo nmcli con down "$NEW_CONN" && sudo nmcli con up "$NEW_CONN"
echo "DNS configured successfully!"

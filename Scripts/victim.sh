#!/bin/bash


if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <ip> <domain> <platform>"
    exit 1
fi

ip="$1"
domain="$2"
platform="$3"
hosts_file="/etc/hosts"
zshrc_file="$HOME/.zshrc"

if grep -q "$domain" "$hosts_file"; then
    sudo sed -i "/$domain/d" "$hosts_file"
fi

platform_section=$(grep -nE "# ====== $platform ======" "$hosts_file" | cut -d':' -f1)
if [ -n "$platform_section" ]; then
    sudo sed -i "${platform_section}a $ip $domain" "$hosts_file"
else
    echo -e "\n# ====== $platform ======" | sudo tee -a "$hosts_file"
    echo "$ip $domain" | sudo tee -a "$hosts_file"
fi

if grep -q "export VMIP=" "$zshrc_file"; then
    sed -i "/export VMIP=/d" "$zshrc_file"
fi

echo "export VMIP=\"$ip\"" >> "$zshrc_file" 
echo "Entry added/updated in /etc/hosts under platform $platform:"
grep "$domain" "$hosts_file"
echo "VMIP variable updated in $zshrc_file:"
grep "export VMIP=" "$zshrc_file"

#!/bin/bash


# Trevohack's TryHackMe Lab Setup 
# curl -O https://raw.githubusercontent.com/Trevohack/TryHackMe-Zero-To-Hero/main/Scripts/setup.sh && chmod +x setup.sh && ./setup.sh

sudo mkdir -p /opt/utils/
sudo mkdir -p /opt/wordlists/
sudo mkdir -p ~/THM/
sudo mkdir -p ~/THM/Writeups/
sudo mkdir -p ~/THM/VPN/

install_package() {
    package_name=$1
    echo "Installing $package_name..."
    sudo apt-get install -y $package_name
}

allow_port() {
    port=$1
    echo "Allowing incoming traffic on port $port..."
    sudo ufw allow $port
}
sudo ufw enable 
allow_port 1337  # Adjust to your specific needs
allow_port 4444  # Adjust to your specific needs
allow_port 8000  # Adjust to your specific needs
allow_port 9001  # Adjust to your specific needs
allow_port 31337 # Adjust to your specific needs

echo "Allowing ICMP (ping)..."
sudo ufw allow icmp
echo "Allowing all outgoing connections..."
sudo ufw default allow outgoing
echo "CTF-friendly firewall configuration complete!"

sudo mkdir -p /opt/utils/
sudo mkdir -p /opt/wordlists/
sudo mkdir -p ~/THM/
sudo mkdir -p ~/THM/Writeups/
sudo mkdir -p ~/THM/VPN/

install_package "nmap"
install_package "metasploit-framework"
install_package "httpie"
install_package "lynx"

echo "Installing rustscan..."
cd /opt/utils
wget https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb
sudo dpkg -i rustscan_2.0.1_amd64.deb
rm rustscan_2.0.1_amd64.deb

echo "Installing pspy64..."
cd /opt/utils
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64
chmod +x pspy64

echo "Downloading linpeas.sh..."
cd /opt/utils
wget https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/linPEAS/linpeas.sh
chmod +x linpeas.sh

echo "Downloading linux-exploit-suggestor.sh..."
cd /opt/utils
wget https://github.com/mzet-/linux-exploit-suggester/raw/master/linux-exploit-suggester.sh
chmod +x linux-exploit-suggester.sh

echo "Downloading wordlists..."
cd /opt/wordlists
wget https://github.com/assetnote/commonspeak2-wordlists/raw/master/subdomains/subdomains.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Leaked-Databases/rockyou-75.txt


echo 'export LHOST="$(ip -o -4 addr show tun0 | awk '\''{print $4}'\'' | cut -d "/" -f 1)"' >> $HOME/.zshrc 
echo 'export ROCKYOU="/opt/wordlists/rockyou-75.txt"' >> $HOME/.zshrc 
echo 'alias vpn="sudo openvpn ~/THM/VPN/<vpn_file.ovpn"' >> $HOME/.zshrc 

curl https://raw.githubusercontent.com/Trevohack/TryHackMe-Zero-To-Hero/main/Scripts/victim.sh -O /opt/utils/victim.sh && chmod +x /opt/utils/victim.sh && cp /opt/utils/victim.sh /usr/bin/victim
curl https://raw.githubusercontent.com/Trevohack/TryHackMe-Zero-To-Hero/main/Scripts/scan.sh -O /opt/utils/scan.sh && chmod +x /opt/utils/scan.sh && cp /opt/utils/scan.sh /usr/bin/scanhost

echo "Installation complete!"


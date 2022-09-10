#!/bin/bash
#root?
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi

set -e  # stop script if something goes wrong

#open ports
apt update && apt upgrade -y
apt install firewalld -y
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --permanent --add-port=1-65535/udp
firewall-cmd --zone=public --permanent --add-port=1-65535/tcp
firewall-cmd --reload
firewall-cmd --zone=public --list-all

iptables -A INPUT -p udp -m udp --dport 1:65535 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 1:65535 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
#echo
echo "All ports open sucsesfully"

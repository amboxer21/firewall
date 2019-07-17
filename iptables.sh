#!/bin/bash
### BEGIN INIT INFO
# Provides:          iptables.sh
# Required-Start:    mountkernfs $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Script to add default preferred iptable rules.
# Description:       (None) 
### END INIT INFO


# Author: Anthony Guevara <amboxer21@gmail.com>

wired_iface = `ifconfig | awk -F: '/^e[a-z0-9]*/{print $1}' | head -n1`

/sbin/iptables --flush

# Used to forward remote VPN traffic through gateway
sudo iptables -A FORWARD -p tcp -i tun0 -o $wired_iface -s 10.8.0.0/24 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $wired_iface -j MASQUERADE

/sbin/iptables -v -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -v -A INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -v -A INPUT -p tcp --dport 443 -j ACCEPT
/sbin/iptables -v -A INPUT -p tcp --dport 1194 -j ACCEPT
/sbin/iptables -v -A INPUT -p tcp --dport 1199 -j ACCEPT

/sbin/iptables -v -A OUTPUT -p tcp -d github.com --dport 1199 -j ACCEPT

for port in 25 53 80 443 587; do /sbin/iptables -v -A OUTPUT -p tcp --dport $port -j ACCEPT; done
for port in 80 443; do /sbin/iptables -v -A INPUT -p tcp --dport $port -j ACCEPT; done
for port in 23 25 587; do /sbin/iptables -v -A INPUT -p tcp --dport $port -j REJECT; done

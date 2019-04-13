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

/sbin/iptables --flush

/sbin/iptables -v -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -v -A OUTPUT -p tcp -d github.com --dport 1199 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 8 -j DROP

for port in 25 53 80 443 587; do /sbin/iptables -v -A OUTPUT -p tcp --dport $port -j ACCEPT; done
for port in 80 443; do /sbin/iptables -v -A INPUT -p tcp --dport $port -j ACCEPT; done
for port in 23 25 587; do /sbin/iptables -v -A INPUT -p tcp --dport $port -j REJECT; done

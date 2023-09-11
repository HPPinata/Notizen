#!/bin/bash

cp /etc/network/interfaces /etc/network/interfaces.bak
sed -n '1h;1!H;${g;s/iface vmbr0.*10.1/iface vmbr0 inet dhcp/;p;}' /etc/network/interfaces.bak > /etc/network/interfaces

VAR=$(cat <<'EOL'

iface enp8s0 inet manual
auto vmbr0
iface vmbr0 inet dhcp
        bridge-ports enp8s0
        bridge-stp off
        bridge-fd 0

EOL
)

VAR=$(VAR=${VAR@Q}; echo "${VAR:2:-1}")
sed -i -E "s+iface enp8s0 inet (auto|dhcp)+$VAR+g" /etc/network/interfaces

cat /etc/network/interfaces

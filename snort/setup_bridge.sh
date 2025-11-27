#!/bin/bash
set -e

ip link add name br0 type bridge
ip addr add 192.168.0.100/24 dev br0
ip link set br0 up

ip link set eth0 master br0
ip link set eth0 up

ip addr flush dev eth0
ip addr add 192.168.0.10/24 dev br0
ip route replace default via 192.168.0.1 dev br0

#! /usr/bin/bash

# Possible outputs of command ufw status
active="Status: active"
inactive="Status: inactive"

# Get firewall status
status="disabled"
status=$(ufw status)

if [[ $status == $active ]]; then
    echo "Firewall is active"
elif [[ $status == $inactive ]]; then
    echo "Firewall is inactive"
else
    echo "Firewall is not set up"
fi

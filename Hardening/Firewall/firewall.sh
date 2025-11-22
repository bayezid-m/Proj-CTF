#! /usr/bin/bash

success=0
isActive=0
isConfigured=0

# Possible outputs of command ufw status
active="Status: active"
inactive="Status: inactive"

# Get firewall status
statusActive=$(ufw status | grep -o "$active")
statusInactive=$(ufw status | grep -o "$inactive")

if [[ $statusActive == $active ]]; then
    echo "Firewall is active"
    isActive=1
elif [[ $statusInactive == $inactive ]]; then
    echo "Firewall is inactive"
else
    echo "Firewall is not set up"
fi

defaultDeny="Default: deny (incoming)"
allowNginx="443/tcp (Nginx HTTPS)      ALLOW IN"
limitSsh="22/tcp                     LIMIT IN"

isDefaultDeny=$(ufw status verbose | grep -o "$defaultDeny")
isAllowNginx=$(ufw status verbose | grep -o "$allowNginx")
isLimitSsh=$(ufw status verbose | grep -o "$limitSsh")

if [[ $isDefaultDeny == $defaultDeny && $isAllowNginx == $allowNginx && $isLimitSsh == $limitSsh ]]; then
    echo "Firewall is configured"
    isConfigured=1
else
    echo "Firewall is not configured"
fi

if [[ $isActive == 1 && $isConfigured == 1 ]]; then
    echo "Flag: asdfasdg"
fi

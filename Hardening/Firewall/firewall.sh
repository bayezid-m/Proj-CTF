#! /usr/bin/bash

success=0
isActive=0
isConfigured=0

# Possible outputs of command ufw status
active="Status: active"
inactive="Status: inactive"

# Get firewall status
statusActive=$(ufw status 2>/dev/null | grep -o "$active" 2>/dev/null)
statusInactive=$(ufw status 2>/dev/null | grep -o "$inactive" 2>/dev/null)

if [[ $statusActive == $active ]]; then
    echo "Firewall is active"
    isActive=1
elif [[ $statusInactive == $inactive ]]; then
    echo "Firewall is inactive"
else
    echo "Firewall is not set up"
fi

# Check firewall configuration
defaultDeny="Default: deny (incoming)"
allowNginx="443/tcp (Nginx HTTPS)      ALLOW IN"
limitSsh="22/tcp                     LIMIT IN"

isDefaultDeny=$(ufw status verbose 2>/dev/null | grep -o "$defaultDeny" 2>/dev/null)
isAllowNginx=$(ufw status verbose 2>/dev/null | grep -o "$allowNginx" 2>/dev/null)
isLimitSsh=$(ufw status verbose 2>/dev/null | grep -o "$limitSsh" 2>/dev/null)

if [[ $isDefaultDeny == $defaultDeny && $isAllowNginx == $allowNginx && $isLimitSsh == $limitSsh ]]; then
    echo "Firewall is configured"
    isConfigured=1
else
    echo "Firewall is not configured"
fi

# On success, give player the flag
if [[ $isActive == 1 && $isConfigured == 1 ]]; then
    echo "Flag: YouAreNext"
fi

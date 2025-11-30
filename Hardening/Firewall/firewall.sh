#! /usr/bin/bash

# If something fails, set this to 0
success=1

# Possible outputs of command ufw status
active="Status: active"
inactive="Status: inactive"

# Get firewall status
statusActive=$(ufw status 2>/dev/null | grep -o "$active" 2>/dev/null)
statusInactive=$(ufw status 2>/dev/null | grep -o "$inactive" 2>/dev/null)

if [[ $statusActive == $active ]]; then
    echo ""
    echo "Success! Firewall is active!"
elif [[ $statusInactive == $inactive ]]; then
    echo ""
    echo "Failure! Firewall is inactive!"
    success=0
else
    echo ""
    echo "Failure! Ufw is not installed!"
    success=0
fi

# Check firewall configuration
defaultDeny="Default: deny (incoming)"
allowNginx="443/tcp (Nginx HTTPS)      ALLOW IN"
limitSsh="22/tcp                     LIMIT IN"

isDefaultDeny=$(ufw status verbose 2>/dev/null | grep -o "$defaultDeny" 2>/dev/null)
isAllowNginx=$(ufw status verbose 2>/dev/null | grep -o "$allowNginx" 2>/dev/null)
isLimitSsh=$(ufw status verbose 2>/dev/null | grep -o "$limitSsh" 2>/dev/null)

if [[ $isDefaultDeny == $defaultDeny ]]; then
    echo ""
    echo "Success! Default connection policy is configured correctly!"
else
    echo ""
    echo "Failure! Default connection policy is not configured correctly!"
    success=0
fi
if [[ $isAllowNginx == $allowNginx ]]; then
    echo ""
    echo "Success! Policy for Nginx is configured correctly!"
else
    echo ""
    echo "Failure! Policy for Nginx is not configured correctly!"
    success=0
fi
if [[ $isLimitSsh == $limitSsh ]]; then
    echo ""
    echo "Success! Policy for SSH is configured correctly!"
else
    echo ""
    echo "Failure! Policy for SSH is not configured correctly!"
    success=0
fi

# On success, give player the flag
if [[ $success == 1 ]]; then
    echo ""
    echo "Success! Firewall is configured correctly!"
    echo ""
    echo "Flag: YouAreNext"
else
    echo ""
    echo "Failure! Firewall is not configured correctly!"
fi

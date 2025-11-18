#! /usr/bin/bash

# Check if password authentication is enabled

nopasswd="PasswordAuthentication no"

checkpasswdauth=$(cat /etc/ssh/sshd_config | grep "PasswordAuthentication no")

if [[ $checkpasswdauth == $nopasswd ]]; then
    echo "Success! Flag: asdf"
else
    echo "Failure"
fi

# Check if authentication is allowed only for user kali

allowedusers="AllowUsers kali"

checkallowedusers=$(cat /etc/ssh/sshd_config | grep "AllowUsers kali")

if [[ $checkallowedusers == $allowedusers ]]; then
    echo "Success! Flag: dfgh"
else
    echo "Failure"
fi

# TODO: SSH keys

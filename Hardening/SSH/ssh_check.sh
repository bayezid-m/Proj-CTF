#! /usr/bin/bash

# Check if password authentication is enabled

isPasswordAuth=0
noPasswd="PasswordAuthentication no"

checkPasswdAuth=$(cat /etc/ssh/sshd_config | grep "PasswordAuthentication no")

if [[ $checkPasswdAuth == $noPasswd ]]; then
    echo "Success! Password authentication is set up correctly!"
    isPasswordAuth=1
else
    echo "Failure! Password authentication is not set up correctly!"
fi

# Check if authentication is allowed only for user kali

isUserAuth=0
allowedUsers="AllowUsers kali"

checkAllowedUsers=$(cat /etc/ssh/sshd_config | grep "AllowUsers kali")

if [[ $checkAllowedUsers == $allowedUsers ]]; then
    echo "Success! User authentication is set up correctly!"
    isUserAuth=1
else
    echo "Failure! User authentication is not set up correctly!"
fi

# Check if client and server keys match

isSshKeys=0
publicKey=$(cat /home/kali/.ssh/id_ed25519.pub)
authorizedKeys=$(cat /home/kali/.ssh/authorized_keys)

if [[ $publicKey == "" || $authorizedKeys == "" ]]; then
    echo "Failure! SSH keys are not configured correctly!"
elif [[ $publicKey == $authorizedKeys ]]; then
    echo "Success! SSH keys are configured correctly!"
    isSshKeys=1
else
    echo "Failure! SSH keys are not configured correctly!"
fi

if [[ $isPasswordAuth == 1 && $isUserAuth == 1 && $isSshKeys == 1 ]]; then
    echo "Flag: gkjhfdlkgj"
fi

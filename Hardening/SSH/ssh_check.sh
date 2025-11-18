#! /usr/bin/bash

# Check if password authentication is enabled

noPasswd="PasswordAuthentication no"

checkPasswdAuth=$(cat /etc/ssh/sshd_config | grep "PasswordAuthentication no")

if [[ $checkPasswdAuth == $noPasswd ]]; then
    echo "Success! Flag: asdf"
else
    echo "Failure"
fi

# Check if authentication is allowed only for user kali

allowedUsers="AllowUsers kali"

checkAllowedUsers=$(cat /etc/ssh/sshd_config | grep "AllowUsers kali")

if [[ $checkAllowedUsers == $allowedUsers ]]; then
    echo "Success! Flag: dfgh"
else
    echo "Failure"
fi

# Check if ssh keys have been set up using correct email

sshEmail="your_email@example.com"
checkServerSshEmail=$(cat /home/kali/.ssh/authorized_keys | grep -o "your_email@example.com")

if [[ $checkServerSshEmail == $sshEmail ]]; then
    echo "Success! Flag: epwroit"
else
    echo "Failure"
fi

# Check that SSH keys have been set up properly

# DOESN'T WORK FOR NOW

# clientPubKeyFile=$(ls /home/kali/.ssh | grep "pub")

# checkHostPubKeyFile=$(cat /home/kali/.ssh/authorized_keys | grep -o $clientPubKeyFile)

# echo $clientPubKeyFile
# echo $checkHostPubKeyFile

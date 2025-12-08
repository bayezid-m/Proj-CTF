#!/bin/bash

# Change keyboard layout to Finnish in /etc/default/keyboard
sudo sed -i 's/^XKBLAYOUT=.*/XKBLAYOUT="fi"/' /etc/default/keyboard

# Reconfigure keyboard-configuration package silently
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive keyboard-configuration

# Restart keyboard setup service to apply changes immediately
sudo service keyboard-setup restart
setxkbmap fi
echo "Keyboard layout changed to Finnish."
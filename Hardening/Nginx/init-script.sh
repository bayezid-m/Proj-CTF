#!/bin/bash
# setup_nginx.sh — install and configure nginx to serve HTTP on port 80

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Updating package lists ==="
sudo apt update -y

echo "=== Installing Nginx ==="
sudo apt install -y nginx

echo "=== Enabling and starting Nginx ==="
sudo systemctl enable nginx
sudo systemctl start nginx

# TODO Create secret file that should no be served

echo "=== Setting correct permissions ==="
sudo chown -R www-data:www-data /var/www/html

echo "=== Allowing HTTP traffic through firewall (if using ufw) ==="
if command -v ufw >/dev/null 2>&1; then
  sudo ufw allow 'Nginx HTTP'
  sudo ufw reload
fi

echo "=== Verifying Nginx status ==="
sudo systemctl status nginx --no-pager

echo "=== Done! ==="
echo "You can now open http://localhost or your server's IP in a browser."

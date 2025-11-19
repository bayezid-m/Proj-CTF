#! /usr/bin/bash
# set up self-signed certificate after nginx has been setup
# run as root
mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt
mv ./nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx
chmod 644 /etc/nginx/ssl/nginx-selfsigned.crt
chmod 600 /etc/nginx/ssl/nginx-selfsigned.key

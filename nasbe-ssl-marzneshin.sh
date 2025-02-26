#!/bin/bash

# Asking the user for the domain name with blue background, only "Please" blinking in bright yellow
read -p $'\e[44;93;5mPlease\e[0m\e[44;93m enter your domain name (e.g., example.com): \e[0m' domain

# Installing prerequisites
sudo apt update
sudo apt install snapd -y
sudo apt install certbot -y

# Obtaining SSL certificate with Certbot
sudo certbot certonly --standalone -d "$domain"

# Creating folder and copying certificate files
mkdir -p /var/lib/marzneshin/certs/"$domain"
cp /etc/letsencrypt/live/"$domain"/fullchain.pem /var/lib/marzneshin/certs/"$domain"/fullchain.pem
cp /etc/letsencrypt/live/"$domain"/privkey.pem /var/lib/marzneshin/certs/"$domain"/key.pem

# Editing the .env file by adding certificate paths
echo "UVICORN_SSL_CERTFILE=\"/var/lib/marzneshin/certs/$domain/fullchain.pem\"" >> /etc/opt/marzneshin/.env
echo "UVICORN_SSL_KEYFILE=\"/var/lib/marzneshin/certs/$domain/key.pem\"" >> /etc/opt/marzneshin/.env

# Restarting the service
marzneshin restart

echo "Done! SSL certificate for $domain has been set up and the service restarted."

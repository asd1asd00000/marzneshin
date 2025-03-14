#!/bin/bash

# Clear the screen for better visibility
clear

# Ask user for email address
echo -e "\e[42mEnter your email address:\e[0m"
read email

# Ask user for domain name
echo -e "\e[42mEnter your domain name:\e[0m"
read domain

# Update package lists
apt-get update

# Install necessary packages
apt install curl socat -y

# Install acme.sh
curl https://get.acme.sh | sh

# Set default CA to Let's Encrypt
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# Register account
~/.acme.sh/acme.sh --register-account -m $email

# Issue certificate for the domain
~/.acme.sh/acme.sh --issue -d $domain --standalone

# Create directory for certificates
mkdir -p /var/lib/marznode/certs

# Install the certificate
~/.acme.sh/acme.sh --installcert -d $domain --key-file /var/lib/marznode/certs/private.key --fullchain-file /var/lib/marznode/certs/cert.crt

# Display final instructions to the user
echo -e "\e[42mPlease add the following lines to your configuration:\e[0m"
echo -e "\e[42m/var/lib/marznode/certs/cert.crt\e[0m"
echo -e "\e[42m/var/lib/marznode/certs/private.key\e[0m"

#!/bin/bash

# Define color codes
WHITE_BBLUE_BOLD='\033[1;37;44m' # Bold white text (1;37) with blue background (44)
BLINK='\033[5m' # Blinking text
NC='\033[0m' # No Color

# Step 1: Update system and install required packages
echo "Updating system and installing required packages..."
apt update
apt install git nano curl -y
curl -fsSL https://get.docker.com | sh

# Step 2: Create directory structure
echo "Creating directory structure..."
mkdir -p /var/lib/marznode/

# Step 3: Prompt user to press a key before opening nano for client.pem
echo -e "${WHITE_BBLUE_BOLD}Opening nano editor - Please paste your certificate key and save (Ctrl+O, Enter, Ctrl+X)${NC}"
echo -e "${BLINK}Press any key to open the certificate file...${NC}"
read -n 1 -s # Waits for user to press any key silently
nano /var/lib/marznode/client.pem

# Step 4: Download xray_config.json
echo "Downloading xray_config.json..."
curl -L https://github.com/marzneshin/marznode/raw/master/xray_config.json > /var/lib/marznode/xray_config.json

# Step 5: Clone repository
echo "Cloning marznode repository..."
git clone https://github.com/marzneshin/marznode

# Step 5.5: Change to marznode directory
echo "Changing to marznode directory..."
cd marznode

# New Step 6: Ask for port number and modify compose.yml with proper indentation
echo -e "${WHITE_BBLUE_BOLD}${BLINK}Please enter the desired port number for the service:${NC}"
read port_number
echo "Adding SERVICE_PORT to compose.yml with port $port_number..."
sed -i "/environment:/a \ \ \ \ \ \ SERVICE_PORT: \"$port_number\"" compose.yml

# Step 7: Start docker compose
echo "Starting docker compose services..."
docker compose -f ./compose.yml up -d

echo "Setup completed!"

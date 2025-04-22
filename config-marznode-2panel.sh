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

# Step 2: Create directory structure for both panels
echo "Creating directory structure for both panels..."
mkdir -p /var/lib/marznode1/
mkdir -p /var/lib/marznode2/

# Step 3: Prompt user to input certificate for panel 1
echo -e "${WHITE_BBLUE_BOLD}Opening nano editor for Panel 1 - Please paste your certificate key and save (Ctrl+O, Enter, Ctrl+X)${NC}"
echo -e "${BLINK}Press any key to open the certificate file for Panel 1...${NC}"
read -n 1 -s # Waits for user to press any key silently
nano /var/lib/marznode1/client.pem

# Step 4: Prompt user to input certificate for panel 2
echo -e "${WHITE_BBLUE_BOLD}Opening nano editor for Panel 2 - Please paste your certificate key and save (Ctrl+O, Enter, Ctrl+X)${NC}"
echo -e "${BLINK}Press any key to open the certificate file for Panel 2...${NC}"
read -n 1 -s # Waits for user to press any key silently
nano /var/lib/marznode2/client.pem

# Step 5: Download xray_config.json for both panels
echo "Downloading xray_config.json for both panels..."
curl -L https://github.com/marzneshin/marznode/raw/master/xray_config.json > /var/lib/marznode1/xray_config.json
curl -L https://github.com/marzneshin/marznode/raw/master/xray_config.json > /var/lib/marznode2/xray_config.json

# Step 6: Clone repository
echo "Cloning marznode repository..."
git clone https://github.com/marzneshin/marznode

# Step 7: Change to marznode directory
echo "Changing to marznode directory..."
cd marznode

# Step 8: Ask for port numbers for both panels
echo -e "${WHITE_BBLUE_BOLD}${BLINK}Please enter the desired port number for Panel 1:${NC}"
read port_number1
echo -e "${WHITE_BBLUE_BOLD}${BLINK}Please enter the desired port number for Panel 2:${NC}"
read port_number2

# Step 9: Create compose.yml with configurations for both panels
echo "Creating compose.yml with configurations for both panels..."
cat > compose.yml <<EOL
services:
  marznode1:
    image: dawsh/marznode:latest
    restart: always
    network_mode: host
    command: [ "sh", "-c", "sleep 10 && python3 marznode.py" ]
    environment:
      SERVICE_PORT: "$port_number1"
      XRAY_EXECUTABLE_PATH: "/usr/local/bin/xray"
      XRAY_ASSETS_PATH: "/usr/local/lib/xray"
      XRAY_CONFIG_PATH: "/var/lib/marznode1/xray_config.json"
      SING_BOX_EXECUTABLE_PATH: "/usr/local/bin/sing-box"
      HYSTERIA_EXECUTABLE_PATH: "/usr/local/bin/hysteria"
      SSL_CLIENT_CERT_FILE: "/var/lib/marznode1/client.pem"
      SSL_KEY_FILE: "./server.key"
      SSL_CERT_FILE: "./server.cert"
    volumes:
      - /var/lib/marznode1:/var/lib/marznode1

  marznode2:
    image: dawsh/marznode:latest
    restart: always
    network_mode: host
    command: [ "sh", "-c", "sleep 10 && python3 marznode.py" ]
    environment:
      SERVICE_PORT: "$port_number2"
      XRAY_EXECUTABLE_PATH: "/usr/local/bin/xray"
      XRAY_ASSETS_PATH: "/usr/local/lib/xray"
      XRAY_CONFIG_PATH: "/var/lib/marznode2/xray_config.json"
      SING_BOX_EXECUTABLE_PATH: "/usr/local/bin/sing-box"
      HYSTERIA_EXECUTABLE_PATH: "/usr/local/bin/hysteria"
      SSL_CLIENT_CERT_FILE: "/var/lib/marznode2/client.pem"
      SSL_KEY_FILE: "./server.key"
      SSL_CERT_FILE: "./server.cert"
    volumes:
      - /var/lib/marznode2:/var/lib/marznode2
EOL

# Step 10: Start docker compose
echo "Starting docker compose services..."
docker compose -f ./compose.yml up -d

echo "Setup completed for both panels!"

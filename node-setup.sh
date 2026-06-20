#!/bin/bash

# --- Colors for Output ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Root Check ---
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run this script as root (sudo).${NC}"
  exit 1
fi

echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}   Abdal VPN Manager - Multi-Server Setup Script    ${NC}"
echo -e "${CYAN}====================================================${NC}"
echo -e "1. Install as ${GREEN}MAIN SERVER${NC} (Database + Master Node)"
echo -e "2. Install as ${YELLOW}NODE SERVER${NC} (Connects to Main Server)"
echo -e "3. Exit"
echo -e "${CYAN}====================================================${NC}"
read -p "Select an option [1-3]: " setup_choice

# --- CRONJOB FUNCTION ---
setup_cron() {
    echo -e "${CYAN}Setting up 3-minute Cronjob for auto-kill...${NC}"
    CRON_CMD="*/3 * * * * /bin/bash /root/abdal-user-manager.sh --check >/dev/null 2>&1"
    # Check if cron already exists to avoid duplicates
    if crontab -l 2>/dev/null | grep -q "/root/abdal-user-manager.sh --check"; then
        echo -e "${YELLOW}Cronjob already exists! Skipping.${NC}"
    else
        (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
        systemctl restart cron
        echo -e "${GREEN}Cronjob installed successfully.${NC}"
    fi
}

case $setup_choice in
    1)
        echo -e "\n${GREEN}--- Setting up MAIN SERVER ---${NC}"
        
        read -p "Enter the new NODE SERVER IP (or % to allow all IPs - not recommended): " NODE_IP
        read -p "Enter a strong password for Database: " DB_PASS

        echo "Installing MariaDB Server..."
        apt update && apt install mariadb-server mariadb-client dos2unix -y
        systemctl enable mariadb
        systemctl start mariadb

        echo "Configuring Database Binding (Allowing external connections)..."
        sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
        systemctl restart mariadb

        echo "Creating Database and User Privileges..."
        mysql -e "CREATE DATABASE IF NOT EXISTS vpn_management;"
        mysql -e "GRANT ALL PRIVILEGES ON vpn_management.* TO 'vpn_admin'@'localhost' IDENTIFIED BY '${DB_PASS}';"
        mysql -e "GRANT ALL PRIVILEGES ON vpn_management.* TO 'vpn_admin'@'${NODE_IP}' IDENTIFIED BY '${DB_PASS}';"
        mysql -e "FLUSH PRIVILEGES;"

        echo "Updating local abdal-user-manager.sh..."
        if [ -f "/root/abdal-user-manager.sh" ]; then
            sed -i "s/DB_HOST=.*/DB_HOST=\"localhost\"/" /root/abdal-user-manager.sh
            sed -i "s/DB_PASS=.*/DB_PASS=\"${DB_PASS}\"/" /root/abdal-user-manager.sh
            dos2unix /root/abdal-user-manager.sh
        else
            echo -e "${YELLOW}Warning: /root/abdal-user-manager.sh not found. Please update DB credentials manually.${NC}"
        fi

        setup_cron
        
        echo -e "${GREEN}Main Server setup is complete!${NC}"
        ;;
        
    2)
        echo -e "\n${YELLOW}--- Setting up NODE SERVER ---${NC}"
        
        read -p "Enter the MAIN SERVER IP: " MAIN_IP
        read -p "Enter the Database Password (created on Main Server): " DB_PASS

        echo "Installing MariaDB Client..."
        apt update && apt install mariadb-client dos2unix -y

        echo "Updating local abdal-user-manager.sh..."
        if [ -f "/root/abdal-user-manager.sh" ]; then
            sed -i "s/DB_HOST=.*/DB_HOST=\"${MAIN_IP}\"/" /root/abdal-user-manager.sh
            sed -i "s/DB_PASS=.*/DB_PASS=\"${DB_PASS}\"/" /root/abdal-user-manager.sh
            dos2unix /root/abdal-user-manager.sh
        else
            echo -e "${YELLOW}Warning: /root/abdal-user-manager.sh not found. Please put the script in /root/ and update credentials manually.${NC}"
        fi

        setup_cron

        echo -e "${GREEN}Node Server setup is complete!${NC}"
        echo -e "${CYAN}You can now run: bash /root/abdal-user-manager.sh${NC}"
        ;;
        
    3)
        echo "Exiting..."
        exit 0
        ;;
        
    *)
        echo -e "${RED}Invalid option selected. Please run the script again.${NC}"
        exit 1
        ;;
esac

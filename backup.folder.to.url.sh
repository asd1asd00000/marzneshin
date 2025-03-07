#!/bin/bash

# Define colors
GREEN='\033[42m\033[30m'  # Green background with black text
NC='\033[0m'               # No color

# Ask the user to choose an option
echo -e "${GREEN}Please choose an option:${NC}"
echo "1- Option 1: Enter the folder paths manually"
echo "2- Option 2: Backup Marzneshin folders"
read -p "$(echo -e "${GREEN}Your choice (1 or 2):${NC} ") " choice

# Determine the backup path based on user choice
if [ "$choice" -eq 1 ]; then
    read -p "$(echo -e "${GREEN}Please enter the folder paths:${NC} ") " backup_path
elif [ "$choice" -eq 2 ]; then
    backup_path="/etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
    backup_name="marzneshin"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Create a zip file of the selected folders
backup_file="/root/$backup_name-$(date +%Y%m%d%H%M%S).zip"
zip -r "$backup_file" $backup_path

# Notify the user about the backup file location
echo "Backup completed successfully. The backup file is stored at:"
echo "$backup_file"

# Start a simple web server to serve the file
echo "Starting a web server for file download..."
echo "لینک تا زمانی فعال است که کنترل سی نزنیم
echo "اگه زدیم یکبار python3 -m http.server 8556 مجدد میزنیم"
echo "===--DOWNLOAD--===[dont use control+c]:"
ip_address=$(hostname -I | awk '{print $1}')
echo -e "${GREEN}http://$ip_address:8556/$(basename $backup_file)${NC}"

# Run the Python web server on port 8556
cd /root
python3 -m http.server 8556

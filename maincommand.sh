#!/bin/bash

# Clear the screen
clear

# Array of scripts with their display names
scripts=(
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/nasbe-marznode.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/ssl_for_marznode.sh)\""
    "sudo bash -c \"\$(curl -sL https://github.com/marzneshin/Marzneshin/raw/master/script.sh)\""
    "marzneshin cli admin create --sudo"
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/nasbe-ssl-marzneshin.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/backup.to.gmail.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/speedtest.sh)\""
    "sudo bash -c \"\$(curl -sL https://github.com/asd1asd00000/marzneshin/raw/refs/heads/main/backup.folder.to.url.sh)\""
    "bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)"
)

# Array of display names for scripts
names=(
    "nasbe marznode"
    "ssl_for_marznode"
    "install Marzneshin"
    "marzneshin cli admin"
    "nasbe-ssl-marzneshin"
    "backup.to.gmail"
    "speedtest"
    "backup.folder.to.url"
    "install mhsanaei 3x-ui"
)

# ANSI color code for blue background
BLUE_BG="\033[44m"
RESET="\033[0m"

# Display list of scripts
echo "List of scripts:"
echo
echo -e "${BLUE_BG}marznode:${RESET}"
echo "1- ${names[0]}"
echo "2- ${names[1]}"
echo
echo -e "${BLUE_BG}marzneshin:${RESET}"
echo "3- ${names[2]}"
echo "4- ${names[3]}"
echo "5- ${names[4]}"
echo
echo "6- ${names[5]}"
echo "7- ${names[6]}"
echo "8- ${names[7]}"
echo "9- ${names[8]}"
echo

# Get user input
read -p "Enter the script number (1 to ${#scripts[@]}): " choice

# Validate input
if [[ ! "$choice" =~ ^[1-9]$ ]]; then
    echo "Invalid input! Please enter a number between 1 and ${#scripts[@]}."
    exit 1
fi

# Convert input to array index (input number - 1)
index=$((choice - 1))

# Execute the selected script
echo "Executing script: ${names[$index]}"
if bash -c "${scripts[$index]}"; then
    echo "Script executed successfully."
else
    echo "Error executing script."
    exit 1
fi

#!/bin/bash

# Array of scripts
scripts=(
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/nasbe-marznode.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/ssl_for_marznode.sh)\""
    "sudo bash -c \"\$(curl -sL https://github.com/marzneshin/Marzneshin/raw/master/script.sh)\""
    "marzneshin cli admin create --sudo"
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/nasbe-ssl-marzneshin.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/backup.to.gmail.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/speedtest.sh)\""
    "sudo bash -c \"\$(curl -sL https://github.com/asd1asd00000/marzneshin/raw/refs/heads/main/backup.folder.to.url.sh)\""
)

# Display list of scripts
echo "List of scripts:"
echo
echo "marznode:"
echo "1- ${scripts[0]}"
echo "2- ${scripts[1]}"
echo
echo "marzneshin:"
echo "3- ${scripts[2]}"
echo "4- ${scripts[3]}"
echo "5- ${scripts[4]}"
echo
echo "6- ${scripts[5]}"
echo "7- ${scripts[6]}"
echo "8- ${scripts[7]}"
echo

# Get user input
read -p "Enter the script number (1 to ${#scripts[@]}): " choice

# Validate input
if [[ ! "$choice" =~ ^[1-8]$ ]]; then
    echo "Invalid input! Please enter a number between 1 and ${#scripts[@]}."
    exit 1
fi

# Convert input to array index (input number - 1)
index=$((choice - 1))

# Execute the selected script
echo "Executing script: ${scripts[$index]}"
if bash -c "${scripts[$index]}"; then
    echo "Script executed successfully."
else
    echo "Error executing script."
    exit 1
fi

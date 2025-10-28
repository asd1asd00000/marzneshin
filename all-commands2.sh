#!/bin/bash

# Clear the screen
clear

# Array of scripts with their display names
scripts=(
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/nasbe-marznode.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/ssl_for_marznode.sh)\""
    "sudo bash -c \"\$(curl -sL https://github.com/marzneshin/Marzneshin/raw/master/script.sh)\" @ install"
    "marzneshin cli admin create --sudo"
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/nasbe-ssl-marzneshin.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/backup.to.gmail.sh)\""
    "sudo bash -c \"\$(curl -sL https://raw.githubusercontent.com/asd1asd00000/marzneshin/refs/heads/main/speed-test.sh)\""
    "sudo bash -c \"\$(curl -sL https://github.com/asd1asd00000/marzneshin/raw/refs/heads/main/backup.folder.to.url.sh)\""
    "bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)"
    "submenu"
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
    "Tools Submenu"
)

# ANSI color code for blue background
BLUE_BG="\033[44m"
RESET="\033[0m"

# Submenu function for option 10
submenu() {
    clear
    echo "Tools Submenu:"
    echo "1- CPU Info"
    echo "2- Speedtest (List Servers)"
    echo "3- Speedtest (Server ID 13628)"
    echo "4- Update & Upgrade System"
    echo "5- Backup Marzneshin Folders"
    echo "6- Edit Cronjob"
    echo "7- Install Astro"
    echo "8- Back to Main Menu"
    echo "9(emty)- nano /var/lib/marznode/xray_config.json"
    echo "10(emty)- cd marznode"
    echo "11(emty)- docker compose -f ./compose.yml up -d"
    echo
    read -p "Enter your choice (1-8): " subchoice

    case $subchoice in
        1)
            echo "Command: cat /proc/cpuinfo"
            cat /proc/cpuinfo
            ;;
        2)
            echo "Command: speedtest --servers"
            speedtest --servers
            ;;
        3)
            echo "Command: speedtest --server-id=13628"
            speedtest --server-id=13628
            ;;
        4)
            echo "Command: apt update && apt upgrade -y"
            apt update && apt upgrade -y
            ;;
        5)
            echo "===---  backup this folder ---===="
            echo "/etc/opt/marzneshin/    .env"
            echo "/var/lib/marzneshin/    sqlite3"
            echo "/var/lib/marznode/"
            ;;
        6)
            echo "Command: crontab -e"
            crontab -e
            ;;
        7)
            echo "Command: bash <(curl -Ls https://raw.githubusercontent.com/Soroushnk/Astro/main/Astro.sh)"
            bash <(curl -Ls https://raw.githubusercontent.com/Soroushnk/Astro/main/Astro.sh)
            ;;
        8)
            main_menu
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
    if [ "$subchoice" != "8" ]; then
        read -p "Press Enter to continue..."
    fi
    submenu
}

# Main menu display
main_menu() {
    clear
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
    echo "10- ${names[9]}"
    echo

    # Get user input
    read -p "Enter the script number (1 to ${#scripts[@]}): " choice

    # Validate input
    if [[ ! "$choice" =~ ^[1-9]|10$ ]]; then
        echo "Invalid input! Please enter a number between 1 and ${#scripts[@]}."
        exit 1
    fi

    # Convert input to array index (input number - 1)
    index=$((choice - 1))

    # Execute the selected script
    echo "Executing: ${names[$index]}"
    if [ "${scripts[$index]}" == "submenu" ]; then
        submenu
    else
        if bash -c "${scripts[$index]}"; then
            echo "Script executed successfully."
        else
            echo "Error executing script."
            exit 1
        fi
    fi
}

# Start the script
main_menu

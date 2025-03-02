#!/bin/bash

# ANSI color codes
YELLOW_BG='\033[43m'  # Yellow background
BLUE_BG='\033[44m'    # Blue background
BLACK_TEXT='\033[30m' # Black text
BLINK='\033[5m'       # Blink effect
RESET='\033[0m'       # Reset to default

# Check if curl is installed, if not install it
if ! command -v curl > /dev/null 2>&1; then
    echo "curl is not installed. Updating packages and installing curl..."
    sudo apt-get update -y && sudo apt-get install curl -y
else
    echo "curl is already installed."
fi

# Check if speedtest is installed, if not set up repository and install
if ! command -v speedtest > /dev/null 2>&1; then
    echo "speedtest is not installed. Adding speedtest-cli repository..."
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    echo "Installing speedtest..."
    sudo apt-get install speedtest -y
else
    echo "speedtest is already installed."
fi

# Infinite loop to keep the script running
while true; do
    # Display server selection menu with alternating yellow and blue boxed numbers
    echo "Please select a server for speed testing:"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 1 ${RESET}) Irancell (Server ID: 4317)"
    echo -e "${BLUE_BG}${BLACK_TEXT} 2 ${RESET}) MCI (Hamrahe Aval) (Server ID: 18512)"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 3 ${RESET}) Pishgaman (Server ID: 32500)"
    echo -e "${BLUE_BG}${BLACK_TEXT} 4 ${RESET}) Hiweb (Server ID: 6794)"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 5 ${RESET}) MabnaTelecom (Server ID: 21031)"
    echo -e "${BLUE_BG}${BLACK_TEXT} 6 ${RESET}) HostIran.net (Server ID: 43844)"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 7 ${RESET}) ATRINNET-SERVCO (Server ID: 22097)"
    echo -e "${BLUE_BG}${BLACK_TEXT} 8 ${RESET}) SYSTEC (Server ID: 57696)"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 9 ${RESET}) Sindad (Server ID: 37820)"
    echo -e "${BLUE_BG}${BLACK_TEXT} 10 ${RESET}) PentaHost (Server ID: 68756)"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 11 ${RESET}) Exit"

    # Get user input with blinking (1-11)
    echo -ne "Enter the number of your choice ${BLINK}(1-11)${RESET}: "
    read choice

    # Check user choice and execute corresponding command
    case $choice in
        1)
            echo "Running speed test with Irancell server..."
            speedtest --server-id=4317
            ;;
        2)
            echo "Running speed test with MCI (Hamrahe Aval) server..."
            speedtest --server-id=18512
            ;;
        3)
            echo "Running speed test with Pishgaman server..."
            speedtest --server-id=32500
            ;;
        4)
            echo "Running speed test with Hiweb server..."
            speedtest --server-id=6794
            ;;
        5)
            echo "Running speed test with MabnaTelecom server..."
            speedtest --server-id=21031
            ;;
        6)
            echo "Running speed test with HostIran.net server..."
            speedtest --server-id=43844
            ;;
        7)
            echo "Running speed test with ATRINNET-SERVCO server..."
            speedtest --server-id=22097
            ;;
        8)
            echo "Running speed test with SYSTEC server..."
            speedtest --server-id=57696
            ;;
        9)
            echo "Running speed test with Sindad server..."
            speedtest --server-id=37820
            ;;
        10)
            echo "Running speed test with PentaHost server..."
            speedtest --server-id=68756
            ;;
        11)
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid option! Please enter a number between 1 and 11."
            ;;
    esac

    # Add a blank line for readability before the next iteration
    echo ""
done

#!/bin/bash

# ANSI color codes
YELLOW_BG='\033[43m'
BLUE_BG='\033[44m'
BLACK_TEXT='\033[30m'
BLINK='\033[5m'
RESET='\033[0m'

# Check if curl is installed, if not install it
if ! command -v curl > /dev/null 2>&1; then
    echo "curl is not installed. Installing..."
    sudo apt-get update -y && sudo apt-get install curl -y
else
    echo "curl is already installed."
fi

# Check if libatomic1 is installed
if ! dpkg -s libatomic1 > /dev/null 2>&1; then
    echo "libatomic1 is not installed. Installing..."
    sudo apt-get install -y libatomic1
else
    echo "libatomic1 is already installed."
fi

# Check if speedtest is installed, if not install from Ookla .deb
if ! command -v speedtest > /dev/null 2>&1; then
    echo "speedtest is not installed. Installing from Ookla..."

    TEMP_DEB="$(mktemp)" &&
    curl -sLo "$TEMP_DEB" https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux.deb &&
    sudo apt install -y "$TEMP_DEB" &&
    rm -f "$TEMP_DEB"

    if ! command -v speedtest > /dev/null 2>&1; then
        echo "Installation failed. Please try manually from https://www.speedtest.net/apps/cli"
        exit 1
    fi
else
    echo "speedtest is already installed."
fi

# Infinite menu loop
while true; do
    echo "Please select a server for speed testing:"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 1 ) Irancell (Server ID: 4317)${RESET}"
    echo -e "${BLUE_BG}${BLACK_TEXT} 2 ) MCI (Hamrahe Aval) (Server ID: 18512)${RESET}"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 3 ) Pishgaman (Server ID: 32500)${RESET}"
    echo -e "${BLUE_BG}${BLACK_TEXT} 4 ) Hiweb (Server ID: 6794)${RESET}"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 5 ) MabnaTelecom (Server ID: 21031)${RESET}"
    echo -e "${BLUE_BG}${BLACK_TEXT} 6 ) HostIran.net (Server ID: 43844)${RESET}"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 7 ) ATRINNET-SERVCO (Server ID: 22097)${RESET}"
    echo -e "${BLUE_BG}${BLACK_TEXT} 8 ) SYSTEC (Server ID: 57696)${RESET}"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 9 ) Sindad (Server ID: 37820)${RESET}"
    echo -e "${BLUE_BG}${BLACK_TEXT} 10 ) PentaHost (Server ID: 68756)${RESET}"
    echo -e "${YELLOW_BG}${BLACK_TEXT} 11 ) Exit${RESET}"

    echo -ne "Enter the number of your choice ${BLINK}(1-11)${RESET}: "
    read choice

    case $choice in
        1)  echo "Running speed test with Irancell..."; speedtest --server-id=4317 ;;
        2)  echo "Running speed test with MCI..."; speedtest --server-id=18512 ;;
        3)  echo "Running speed test with Pishgaman..."; speedtest --server-id=32500 ;;
        4)  echo "Running speed test with Hiweb..."; speedtest --server-id=6794 ;;
        5)  echo "Running speed test with MabnaTelecom..."; speedtest --server-id=21031 ;;
        6)  echo "Running speed test with HostIran.net..."; speedtest --server-id=43844 ;;
        7)  echo "Running speed test with ATRINNET-SERVCO..."; speedtest --server-id=22097 ;;
        8)  echo "Running speed test with SYSTEC..."; speedtest --server-id=57696 ;;
        9)  echo "Running speed test with Sindad..."; speedtest --server-id=37820 ;;
        10) echo "Running speed test with PentaHost..."; speedtest --server-id=68756 ;;
        11) echo "Exiting..."; exit 0 ;;
        *)  echo "Invalid option. Please enter a number between 1 and 11." ;;
    esac
    echo ""
done

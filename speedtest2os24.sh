#!/bin/bash

# ANSI color codes
YELLOW_BG='\033[43m'
BLUE_BG='\033[44m'
BLACK_TEXT='\033[30m'
BLINK='\033[5m'
RESET='\033[0m'

# Ensure required tools
for pkg in curl wget gnupg1; do
    if ! command -v $pkg > /dev/null 2>&1; then
        echo "$pkg is not installed. Installing..."
        sudo apt-get update && sudo apt-get install -y $pkg
    fi
done

# Ensure libatomic1 is installed
if ! dpkg -s libatomic1 > /dev/null 2>&1; then
    echo "Installing required library libatomic1..."
    sudo apt-get install -y libatomic1
fi

# Detect OS version
OS_VERSION=$(lsb_release -cs)
INSTALL_SPEEDTEST_MANUALLY=false

# Try to install via repository unless on noble
if [[ "$OS_VERSION" == "noble" ]]; then
    INSTALL_SPEEDTEST_MANUALLY=true
else
    echo "Adding Ookla's Speedtest repository..."
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash

    echo "Installing speedtest from repository..."
    sudo apt-get install -y speedtest || INSTALL_SPEEDTEST_MANUALLY=true
fi

# Fallback to manual install if necessary
if $INSTALL_SPEEDTEST_MANUALLY; then
    echo "⚠️  Falling back to manual installation..."
    TEMP_DEB="/tmp/speedtest-cli.deb"
    URL="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux64.deb"

    echo "Downloading speedtest CLI..."
    curl -Lo "$TEMP_DEB" "$URL"

    if [[ -s "$TEMP_DEB" ]]; then
        echo "Installing downloaded package..."
        sudo dpkg -i "$TEMP_DEB" || sudo apt-get install -f -y
        rm -f "$TEMP_DEB"
    else
        echo "❌ Failed to download the speedtest package."
        echo "Please visit https://www.speedtest.net/apps/cli to download manually."
        exit 1
    fi
fi

# Final check
if ! command -v speedtest > /dev/null 2>&1; then
    echo "❌ speedtest installation failed."
    exit 1
else
    echo "✅ speedtest is installed and ready to use!"
fi

# Show menu
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

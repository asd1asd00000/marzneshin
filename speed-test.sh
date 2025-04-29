#!/bin/bash

# ANSI color codes
YELLOW_BG='\033[43m'
BLUE_BG='\033[44m'
BLACK_TEXT='\033[30m'
BLINK='\033[5m'
RESET='\033[0m'

# مسیر فایل نشانگر
FLAG_FILE="/var/run/speedtest_install.flag"

# بررسی وجود فایل نشانگر
if [ -f "$FLAG_FILE" ]; then
    echo "✅ Dependencies already installed. Skipping installation steps."
else
    # اطمینان از نصب curl
    if ! command -v curl > /dev/null 2>&1; then
        echo "Installing curl..."
        sudo apt-get update && sudo apt-get install -y curl
    fi

    # اضافه کردن مخزن speedtest
    echo "Adding speedtest repository..."
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash

    # اصلاح فایل مخزن در صورت وجود عبارت noble
    LIST_FILE="/etc/apt/sources.list.d/ookla_speedtest-cli.list"
    if grep -q "noble" "$LIST_FILE"; then
        echo "Patching repository file to replace 'noble' with 'jammy'..."
        sudo sed -i 's/noble/jammy/g' "$LIST_FILE"
    fi

    # بروزرسانی و نصب speedtest
    sudo apt-get update
    sudo apt-get install -y speedtest

    # بررسی نصب
    if ! command -v speedtest > /dev/null 2>&1; then
        echo "❌ Speedtest installation failed."
        exit 1
    else
        echo "✅ Speedtest installed successfully."
        # ایجاد فایل نشانگر پس از نصب موفق
        sudo touch "$FLAG_FILE"
    fi
fi

# منوی انتخاب سرور
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

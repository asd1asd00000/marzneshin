#!/bin/bash

# مرحله 1: به‌روزرسانی و نصب curl
echo "در حال به‌روزرسانی بسته‌ها و نصب curl..."
sudo apt-get update -y && sudo apt-get install curl -y

# مرحله 2: اجرای اسکریپت نصب مخزن speedtest-cli از packagecloud
echo "در حال افزودن مخزن speedtest-cli..."
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash

# مرحله 3: نصب speedtest
echo "در حال نصب speedtest..."
sudo apt-get install speedtest -y

# مرحله 4: نمایش منو برای انتخاب سرور
echo "نصب با موفقیت انجام شد. لطفاً یک سرور برای تست سرعت انتخاب کنید:"
echo "1) Irancell (سرور ID: 4317)"
echo "2) MCI (Hamrahe Aval) (سرور ID: 18512)"
echo "3) Pishgaman (سرور ID: 32500)"
echo "4) Hiweb (سرور ID: 6794)"
echo "5) MabnaTelecom (سرور ID: 21031)"
echo "6) HostIran.net (سرور ID: 43844)"
echo "7) ATRINNET-SERVCO (سرور ID: 22097)"
echo "8) SYSTEC (سرور ID: 57696)"
echo "9) Sindad (سرور ID: 37820)"
echo "10) PentaHost (سرور ID: 68756)"

# دریافت ورودی کاربر
read -p "شماره گزینه مورد نظر را وارد کنید (1-10): " choice

# بررسی انتخاب کاربر و اجرای دستور مربوطه
case $choice in
    1)
        echo "در حال اجرای تست سرعت با سرور Irancell..."
        speedtest --server-id=4317
        ;;
    2)
        echo "در حال اجرای تست سرعت با سرور MCI (Hamrahe Aval)..."
        speedtest --server-id=18512
        ;;
    3)
        echo "در حال اجرای تست سرعت با سرور Pishgaman..."
        speedtest --server-id=32500
        ;;
    4)
        echo "در حال اجرای تست سرعت با سرور Hiweb..."
        speedtest --server-id=6794
        ;;
    5)
        echo "در حال اجرای تست سرعت با سرور MabnaTelecom..."
        speedtest --server-id=21031
        ;;
    6)
        echo "در حال اجرای تست سرعت با سرور HostIran.net..."
        speedtest --server-id=43844
        ;;
    7)
        echo "در حال اجرای تست سرعت با سرور ATRINNET-SERVCO..."
        speedtest --server-id=22097
        ;;
    8)
        echo "در حال اجرای تست سرعت با سرور SYSTEC..."
        speedtest --server-id=57696
        ;;
    9)
        echo "در حال اجرای تست سرعت با سرور Sindad..."
        speedtest --server-id=37820
        ;;
    10)
        echo "در حال اجرای تست سرعت با سرور PentaHost..."
        speedtest --server-id=68756
        ;;
    *)
        echo "گزینه نامعتبر! لطفاً عددی بین 1 تا 10 وارد کنید."
        ;;
esac

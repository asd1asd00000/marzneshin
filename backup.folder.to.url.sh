#!/bin/bash

# نصب پیش‌نیازها
echo "Checking and installing prerequisites..."
sudo apt update
sudo apt install -y zip python3

# تعریف رنگ‌ها
GREEN='\033[42m\033[30m'  # زمینه سبز با متن مشکی
NC='\033[0m'               # بدون رنگ

# پاک کردن صفحه
clear

# منوی انتخاب
echo -e "${GREEN}Please choose an option:${NC}"
echo -e "1- ====> Enter the 📂 \033[36mFolder\033[0m 📂 paths manually"
echo -e "2- ====> Backup 📂 \033[36mMARZNESHIN\033[0m folders"
echo -e "3- ====> Backup 📂 \033[36mX-UI\033[0m folders"
read -p "$(echo -e "${GREEN}Your choice (1, 2, or 3):${NC} ") " choice

# مسیرهای بکاپ بر اساس انتخاب کاربر
if [ "$choice" -eq 1 ]; then
    read -p "$(echo -e "${GREEN}Please enter the folder paths:${NC} ") " backup_path
    backup_name="manual_backup"
elif [ "$choice" -eq 2 ]; then
    backup_path="/etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
    backup_name="marzneshin"
elif [ "$choice" -eq 3 ]; then
    backup_path="/etc/x-ui/"
    backup_name="x-ui"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# نام فایل بکاپ
read -p "$(echo -e "${GREEN}Please enter a name for the backup file (without extension):${NC} ") " backup_file_name
backup_file="/root/$backup_file_name-$(date +%Y%m%d%H%M%S).zip"

# ایجاد فایل فشرده
zip -r "$backup_file" $backup_path

# اطلاع‌رسانی به کاربر
echo "✅ Backup completed successfully. File saved at:"
echo "$backup_file"

# راه‌اندازی وب‌سرور برای دانلود فایل
echo "🔄 Starting web server for file download..."
echo "📢 لینک تا زمانی فعال است که کنترل-C نزنیم"
echo "📢 اگر قطع شد، دوباره بزنید: python3 -m http.server 8556"
echo -e "\033[1;32m↓\033[0m \033[1;32m↓\033[0m \033[1;32m↓\033[0m DOWNLOAD \033[1;32m↓\033[0m \033[1;32m↓\033[0m \033[1;32m↓\033[0m:"
ip_address=$(hostname -I | awk '{print $1}')
echo -e "${GREEN}http://$ip_address:8556/$(basename $backup_file)${NC}"

# اجرای وب‌سرور
cd /root
python3 -m http.server 8556

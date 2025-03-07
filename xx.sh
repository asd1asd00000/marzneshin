#!/bin/bash

# پرسیدن از کاربر برای انتخاب گزینه
echo "لطفا گزینه مورد نظر را انتخاب کنید:"
echo "1- گزینه اول: آدرس فولدرها را کاربر خودش بدهد"
echo "2- گزینه دوم: بکاپ مرزنشین در لوکال"
read -p "انتخاب شما (1 یا 2): " choice

# تعیین مسیر بکاپ بر اساس انتخاب کاربر
if [ "$choice" -eq 1 ]; then
    read -p "لطفا آدرس فولدرها را وارد کنید: " backup_path
elif [ "$choice" -eq 2 ]; then
    backup_path="/etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
    backup_name="marzneshin"
else
    echo "گزینه نامعتبر انتخاب شده است."
    exit 1
fi

# ایجاد فایل زیپ از فولدرهای انتخاب شده
backup_file="/root/$backup_name-$(date +%Y%m%d%H%M%S).zip"
zip -r "$backup_file" $backup_path

# اعلام موفقیت
echo "بکاپ با موفقیت انجام شد و فایل در مسیر زیر ذخیره شد:"
echo "$backup_file"

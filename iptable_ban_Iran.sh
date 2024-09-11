#!/bin/bash

# نصب پکیج‌های مورد نیاز
sudo apt-get install curl unzip nftables -y

# لینک فایل حاوی رنج‌های CIDR
url="https://raw.githubusercontent.com/LonUp/ALL-IRAN-CIDR/main/IRIPCIDR.txt"
allcount=$(curl -s "$url" | wc -l)

# ایجاد جدول و زنجیره‌های جدید در nftables
sudo nft add table inet filter
sudo nft add chain inet filter output { type filter hook output priority 0 \; }

# خواندن و مسدود کردن رنج‌های آی‌پی
curl -s "$url" | while IFS= read -r line; do
  ((++line_number))
  sudo nft add rule inet filter output ip daddr $line tcp dport { 80, 443 } drop
  clear
  echo "Iran IP Blocking ( List 1 ) : $line_number / $allcount "
done

# ذخیره قوانین nftables
sudo nft list ruleset > /etc/nftables.conf

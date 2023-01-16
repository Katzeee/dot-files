#!/bin/bash
set -e
set -o pipefail
echo -e "\n[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
pacman -Syy
pacman -S archlinuxcn-keyring --noconfirm --needed
pacman -S yay --noconfirm --needed
sed -i '/^#en_US/s/#//'  /etc/locale
sed -i '/^#en_US/s/#//'  /etc/locale
locale-gen
pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts wqy-microhei wqy-zenhei --noconfirm --needed

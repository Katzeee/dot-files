#!/bin/bash
echo "\n[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/$arch\n"
pacman -Syy
pacman -S archlinuxcn-keyring --noconfirm
pacman -S yay --noconfirm
sed -i '/^#en_US/s/#//'  /etc/locale
sed -i '/^#en_US/s/#//'  /etc/locale
locale-gen
pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts wqy-microhei wqy-zenhei --noconfirm

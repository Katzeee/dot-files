#!/bin/bash
set -e
set -o pipefail
if [ `whoami` == "root" ]; then 
  echo "no root"; 
  exit; 
fi

if uname -a | grep -iq ubuntu; then
  sudo apt install zsh -y
else
  yay -S zsh --noconfirm --needed
fi
curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh | sh
cp .zshrc ~/.zshrc
chsh -s /usr/bin/zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

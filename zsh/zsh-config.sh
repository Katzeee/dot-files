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
if [ -d ~/.oh-my-zsh ]; then
  rm -rf ~/.oh-my-zsh
fi
curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh | sh
cp .zshrc ~/.zshrc
chsh -s /usr/bin/zsh

plugin_path=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

if [ -d ${plugin_path} ]; then
  rm -rf ${plugin_path}
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${plugin_path}/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${plugin_path}/fast-syntax-highlighting
git clone https://github.com/jeffreytse/zsh-vi-mode ${plugin_path}/zsh-vi-mode
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ${plugin_path}/.z

source ~/.zshrc

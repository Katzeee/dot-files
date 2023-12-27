# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zmodload zsh/zprof
export PATH=~/.local/bin:~/.npm-global/bin:~/.cargo/bin:$PATH
export EDITOR='nvim'

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# agnoster sonicradish

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # git 
  zsh-autosuggestions
  fast-syntax-highlighting
  zsh-vi-mode
  colored-man-pages
  z
  #command-not-found
)

# The plugin will auto execute this zvm_after_select_vi_mode function
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      # Something you want to do...
    ;;
    $ZVM_MODE_INSERT)
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL)
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL_LINE)
      # Something you want to do...
    ;;
    $ZVM_MODE_REPLACE)
      # Something you want to do...
    ;;
  esac
}

source $ZSH/oh-my-zsh.sh

# Extract all compressed file

extract () {
  if [ -f $1 ] ; then
    file_name=$(basename "$1")
    dir_name="${file_name%.*}"
    mkdir -p "${dir_name}"

    case $1 in
      *.tar.bz2)    tar xvjf $1 -C "${dir_name}"    ;;
      *.tar.gz)     tar xvzf $1 -C "${dir_name}"    ;;
      *.tar.xz)     tar xf $1 -C "${dir_name}"      ;;
      *.bz2)        bunzip2 $1 --stdout > "${dir_name}/${file_name%.*}"   ;;
      *.rar)        unrar x $1 "${dir_name}/"       ;;
      *.gz)         gunzip -c $1 > "${dir_name}/${file_name%.*}"   ;;
      *.tar)        tar xvf $1 -C "${dir_name}"     ;;
      *.tbz2)       tar xvjf $1 -C "${dir_name}"    ;;
      *.tgz)        tar xvzf $1 -C "${dir_name}"    ;;
      *.zip)        unzip $1 -d "${dir_name}"       ;;
      *.Z)          uncompress $1                   ;;
      *.7z)         7z x $1 -o"${dir_name}"         ;;
      *)            echo "don't know how to extract '$1'..." ;;
    esac
    set -- "${dir_name}"/*
    if [ $# -eq 1 ] && [ -d "$1" ]; then
      echo "Only one folder inside '${dir_name}', moving it out..."
      mv "${dir_name}"/* "${dir_name}_temp_for_extract"
      rmdir "${dir_name}"
      mv "${dir_name}_temp_for_extract" "${dir_name}"
    fi
  else
    echo "'$1' is not a valid file!"
  fi
}

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias lg=lazygit
alias ra=ranger
alias ssh='TERM=xterm-256color ssh'
function warn_grep() {
    figlet -f pagga "USE RG"
    grep "$@"
}
alias grep=warn_grep
function warn_find() {
    figlet -f pagga "USE FD"
    find "$@"
}
alias find=warn_find
TERMINAL=alacritty

# nvm
[ -d "$HOME/.nvm" ] && [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm" 
# [ -d "/usr/share/nvm" ] && [ -z "$NVM_DIR" ] && export NVM_DIR="/usr/share/nvm" # You should NOT uncomment this line but cp /usr/share/nvm to ~/.nvm because the privilige
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# wsl proxy
host_ip=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")
ep () {
    export http_proxy="http://$host_ip:7890"
    export https_proxy="http://$host_ip:7890"
}
dp () {
    unset http_proxy
    unset https_proxy
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

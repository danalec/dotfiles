#                 888                     
#                 888                     
#                 888                     
# 88888888.d8888b 88888b. 888d888 .d8888b 
#    d88P 88K     888 "88b888P"  d88P"    
#   d88P  "Y8888b.888  888888    888      
#  d88P        X88888  888888    Y88b.    
# 88888888 88888P'888  888888     "Y8888P 
#
# ░ author ░ Dan Alec <danalec@gmail.com>
# ░  code  ░ https://github.com/danalec/dotfiles
#
# ~danalec/.zshrc
# last modified : 2016-12-25
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# 環境変数の設定

# source zplug configuration
source "$ZDOTDIR/.zplugrc"

# for vi mode
export KEYTIMEOUT=1

# powerlevel9k
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv virtualenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode background_jobs status)

# zsh
#alias open="xdg-open "$@" &>/dev/null"
alias open="open_command"
alias reload='clear; source $ZDOTDIR/.zshrc && rm -rf "$ZPLUG_HOME/zcompdump*" && zsh --version'

# 環境個別設定を読み込む
#(.zshrc.local)
if [ -f "$ZDOTDIR/.zshrc.local" ]; then
  source "$ZDOTDIR/.zshrc.local"
fi

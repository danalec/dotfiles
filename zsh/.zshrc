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
# last modified : 2016-11-10
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# 環境変数の設定 

# zplug
source ~/.zplugrc

# powerlevel9k
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv virtualenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(background_jobs status)

# zsh
alias open="xdg-open "$@" &>/dev/null"
alias reload='clear; source ~/.zshrc && zsh --version'

# keybindings (zkbd compatible hash)
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
#[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
#[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
[[ -n "${key[^[[A]]]}"   ]]  && bindkey  "^[[A"             history-substring-search-up
[[ -n "${key[^[[B]]]}"   ]]  && bindkey  "^[[B"             history-substring-search-down
[[ -n "${key[k]}"        ]]  && bindkey  -M vicmd "k"       history-substring-search-up
[[ -n "${key[j]}"        ]]  && bindkey  -M vicmd "j"       history-substring-search-down

# make sure the terminal is in application mode, when zle is active
# only then are the values from $terminfo valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
		printf '%s' "${terminfo[smkx]}"
	}
	function zle-line-finish () {
		printf '%s' "${terminfo[rmkx]}"
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi
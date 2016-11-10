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

# history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=1024

# setopt
setopt auto_cd              # if command is a path, cd into it
setopt auto_remove_slash    # self explicit
setopt bang_hist            # gang history
setopt chase_links          # resolve symlinks
setopt correct              # try to correct spelling of commands
setopt extended_glob        # activate complex pattern globbing
setopt glob_dots            # include dotfiles in globbing
setopt print_exit_value     # print return value if non-zero
unsetopt bg_nice            # no lower prio for background jobs
unsetopt clobber            # must use >| to truncate existing files
unsetopt hup                # no hup signal at shell exit
unsetopt ignore_eof         # do not exit on end-of-file
unsetopt rm_star_silent     # ask for confirmation for `rm *' or `rm path/*'
setopt no_beep              # 補完候補がないときなどにビープ音を鳴らさない。
#unsetopt beep              # wut
#unsetopt list_beep         # no bell on ambiguous completion
#unsetopt hist_beep         # no bell on error in history
setopt correctall           # 引数のスペル修正。
setopt append_history       # 複数のターミナルセッションは1 zshのコマンド履歴に追加します。
setopt inc_append_history   # シェル出口まで待ってない、それらが入力されてコマンドを追加します。
setopt prompt_subst         # allow functions in the prompt
setopt hist_verify          # show before executing history commands
setopt hist_reduce_blanks   # 余分な空白を削除します.
setopt hist_ignore_space    # 余分な空白を削除します.
setopt hist_ignore_all_dups # no duplicate
#setopt hist_expire_dups_first
#setopt extended_history
#setopt share_history       # share history between sessions
#setopt no_share_history    # セッションごとに履歴を保存。
#setopt hist_ignore_dups    # 歴史の中で重複して無視します。


# aliases
alias ...='cd ../..'
alias ':e'='$EDITOR'
alias ':q'="systemctl poweroff"
alias ':r'="systemctl restart"
alias ':s'='subl3'
alias 'cd..'='cd ../'
alias -- -='cd -'
alias ag="ag --color --color-line-number '0;35' --color-match '46;30' --color-path '4;36'"
alias b='ranger'
alias c="tr -d '\n' | pbcopy"
alias catn="cat -n"
alias cdd='cd -'
alias chmod="chmod -c"
alias chown="chown -c"
alias clbin="curl -F 'clbin=<-' https://clbin.com"
alias cls='clear; ls'
alias count='sort | uniq -c | sort -n'  # count something fed in on stdin
alias cp='cp -ivr'
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'
alias egrep='egrep --color=auto'
alias emacs='$EDITOR'
alias fgrep='fgrep --color=auto'
alias h='history'
alias identify='cat ~/.zhistory | sort | uniq -c | sort -n'
alias ip="curl ipinfo.io/ip"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias irc="irssi"
alias k9='kill -9'
alias ka9='killall -9'
alias l='ls --color -lah'
alias less='less -FSRXc'
alias ll="ls -lahF --color=auto"
alias ln="ln -v"
alias ln='ln -v'
alias lol="base64 </dev/urandom | lolcat"
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias ls='ls --color=auto -hFg --color=auto'
alias lsa='ls -lah --color=auto'
alias lsl="ls -lhF --color=auto"
alias manhtml='man --html=$BROWSER '
alias md='mkdir -v -p'
alias mem_hogs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias mkdir="mkdir -v -p"
alias mkpkg='makepkg'
alias mroe=more
alias mv='mv -iv'
alias nano='$EDITOR'
alias netCons='lsof -i'                             # show all open TCP/IP sockets
alias nFiles='echo $(ls -1 | wc -l)'                # count of non-hidden files in current dir
alias nvimdiff="nvim -d"
alias open="xdg-open "$@" &>/dev/null"
alias path='echo $PATH | tr -s ":" "\n"'
alias pi='seq -f '4/%g' 1 2 99999 | paste -sd-+ | bc -l'
alias prikey="more ~/.ssh/id_rsa | xclip -selection clipboard | echo '=> private key copied to pasteboard.'"
alias pubkey="more ~/.ssh/id_rsa.pub | xclip -selection clipboard | echo '=> public key copied to pasteboard.'"
alias rcp='rsync -v --progress'
alias record="ffmpeg -f x11grab -s 1920x1080 -an -r 16 -loglevel quiet -i :0.0 -b:v 15M -y" #pass a filename
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias rmv='rsync -v --progress --remove-source-files'
alias scp='scp -r'
alias speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip"
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias stripcomments="egrep -v '^([\ \t]*#|$)'"      # strip comment & blank lines from an output
alias t='tree -C'
alias ta="tree -Ca"
alias tempwatch="while :; do sensors; sleep 1 && clear; done;"
alias timer='echo "timer started. stop: ^d" && date && time cat && date'
alias toiletlist='for i in ${TOILET_FONT_PATH:=/usr/share/figlet}/*.{t,f}lf; do j=${i##*/}; echo ""; echo "╓───── "$j; echo "╙────────────────────────────────────── ─ ─ "; echo ""; toilet -d "${i%/*}" -f "$j" "${j%.*}"; done'
alias tree='tree -CAFa -I "CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components" --dirsfirst'
alias up='cd ../'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"' # URL-encode strings
alias vi='$EDITOR'
alias week='date +%V'
alias xsel='xsel -b'
alias ~='cd ~'

# experimental
alias back='popd > /dev/null'
#alias ...='while read line; do echo -n "."; done && echo ""'
#alias cd='pushd > /dev/null'   # experimental
#alias fuck=sudo !!
#alias gp='git push origin HEAD'
#alias npminstall="sudo rm -rf node_modules && sudo npm cache clear && sudo npm cache clean && sudo PYTHON=/usr/bin/python2 npm install"
#alias puush="puush -a"
#alias rainbowclock='while true; do echo "$(date '+%D %T' | toilet -f term -F border --gay)"; sleep 1; done'
#alias rootx='xhost +local:root'

# fun
alias ascii="toilet -t -f 3d"
alias cafe='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias clock='watch -t -n1 "date +%T|figlet -f 3d"'
alias future="toilet -t -f future"
alias matrix="cmatrix -b"
alias multiplication_table='for i in {1..9}; do for j in $(seq 1 $i); do echo -ne $i×$j=$((i*j))\\t;done; echo;done'
alias rusto="toilet -t -f rusto"
alias rustofat="toilet -t -f rustofat"

# git
alias g="hub"
alias ga="git add"
alias gac='git add -A && git commit -m'
alias gb='git branch'
alias gba='git branch -a'
alias gc="git commit -m"
alias gca='git commit -a'
alias gcb='git copy-branch-name'
alias gco="git checkout"
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
alias gdm='git diff master'
alias gf="git fetch"
alias gg="git graph"
alias git="hub"
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gm="git merge"
alias gp="git push"
alias gpr="hub pull-request"
alias gr="git rebase"
alias grep='grep --color=auto'
alias gs="git status"
alias gs='git status -sb'
alias gu="git unstage"

# log
alias apachelogs="less +F /var/log/apache2/error.log"
alias nginxlogs="less +F /var/log/nginx/error.log"
alias herr='tail /var/log/httpd/error_log'

# pacaur
alias pacaru="pacaur --noconfirm --noedit -S "
alias pacauru="pacaru"
alias yaourt="pacaur"

# sudo
alias _='sudo '
alias checkrootkits="sudo rkhunter --update; sudo rkhunter --propupd; sudo rkhunter --check"
alias checkvirus="sudo clamscan --recursive=yes --infected /home"
alias fuck='sudo $(fc -ln -1)'
alias lsock='sudo /usr/sbin/lsof -i -P'             # display open sockets
alias lsocktcp='sudo /usr/sbin/lsof -nP | grep TCP' # display only open TCP sockets
alias lsockudp='sudo /usr/sbin/lsof -nP | grep UDP' # display only open UDP sockets
alias node="sudo node"
alias npm="sudo npm"
alias npminstall="sudo rm -rf node_modules && sudo npm cache clear && sudo npm cache clean && npm install"
alias openports='sudo lsof -i | grep LISTEN'        # all listening connections
alias pacaman="sudo pacman --noconfirm -S "
alias pacman="sudo pacman "
alias please='sudo $(fc -ln -1)'
alias pls='sudo '
alias plz='sudo '
alias showBlocked='sudo ipfw list'                  # all ipfw rules inc/ blocked IPs
alias suco='sudo '
alias sudo='sudo '
alias systemctl="sudo systemctl"
alias updateantivirus="sudo freshclam"

# tar
alias -s bz2='tar -jxvf'
alias -s gz='tar -zxvf'
alias untar='tar -xvf'
alias gz='tar -zcvf'

# trash
alias trash='trash-put'
alias trash_empty="trash-empty"

# zsh
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
# Only then are the values from $terminfo valid.
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

# 環境個別設定を読み込む (.zshrc.local)
#if [ -f "$HOME/.zshrc.local" ]; then
#  source "$HOME/.zshrc.local"
#fi
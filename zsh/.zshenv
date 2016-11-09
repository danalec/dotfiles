#                 888                              
#                 888                              
#                 888                              
# 88888888.d8888b 88888b.  .d88b. 88888b. 888  888 
#    d88P 88K     888 "88bd8P  Y8b888 "88b888  888 
#   d88P  "Y8888b.888  88888888888888  888Y88  88P 
#  d88P        X88888  888Y8b.    888  888 Y8bd8P  
# 88888888 88888P'888  888 "Y8888 888  888  Y88P   
# 
# ░ author ░ Dan Alec <danalec@gmail.com>
# ░  code  ░ https://github.com/danalec/dotfiles
#
# ~danalec/.zshenv
# last modified : 2016-11-09
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# .zshenv is always sourced, it often contains exported variables that should be available to other programs
# for example, $PATH, $EDITOR, and $PAGER are often set in .zshenv also, you can set $ZDOTDIR

# 環境変数
#export LANG=ja_JP.UTF-8         # 日本語環境(ja_JP.UTF-8)
#export LANG=pt-BR.UTF-8         # Português-Brasileiro(pt-BR.UTF-8)
export LANG="en_US.UTF-8"
export LANGUAGE=en_US.UTF-8
export LESSCHARSET=utf-8
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# グローバル変数
export EDITOR='/usr/bin/nvim'
export VISUAL='/usr/bin/nvim'

export BROWSER="chromium"
export IMAGEVIEWER="gthumb"

export KEYTIMEOUT=1   # vi mode

export XAUTHORITY=~/.Xauthority
export DISPLAY=:0

export SSH_KEY_PATH="~/.ssh/id_rsa"
export GIT_EDITOR='/usr/bin/nvim'
export PAGER='less'
export ACK_PAGER='less'
export GEM_HOME=~/.gem
export NPM_PACKAGES="$HOME/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
if [ -f "$HOME/.pythonrc.py" ]; then
  export PYTHONSTARTUP="$HOME/.pythonrc.py"
fi

# OSを確認します
if [ -x /usr/bin/uname ] || [ -x /bin/uname ]; then
    case "`uname -sr`" in
        FreeBSD*); export OS="freebsd" ;;
        Linux*);   export OS="linux"   ;;
        CYGWIN*);  export OS="cygwin"  ;;
        IRIX*);    export OS="irix"    ;;
        OSF1*);    export OS="osf1"    ;;
        SunOS*);   export OS="sunos"   ;;
        Darwin*);  export OS="darwin"  ;;
        *);        export OS="dummy"   ;;
    esac
else
    export OS="dummy"
fi

# ホストネーム
if [ -x /bin/hostname ]; then
    export HOST=`hostname`
fi;
export host=`echo $HOST | sed -e 's/\..*//'`

# リモートから起動するコマンド用の環境変数を設定(必要なら)
export RSYNC_RSH=ssh
export CVS_RSH=ssh

# 言語設定
# international-US keyboard
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla

# デフォルトのブロック・サイズのセット (ls, df, du)
export BLOCKSIZE=1k 

# misc
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='💡 '

# non-login, non-interactive シェルが定義された環境があることを確認します。
#if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#  source "${ZDOTDIR:-$HOME}/.zprofile"
#fi

# 径路
# ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# check if the path exists before setting
if [ -d "$NPM_PACKAGES" ]; then
  path='$NPM_PACKAGES/bin'
  manpath='$NPM_PACKAGES/share/man'
fi
if [ -d "$HOME/.gem/" ]; then
  path='$HOME/.gem/ruby/*/bin'
fi
manpath=(
  $HOME/local/man
  $HOME/local/share/man
  /usr/local/man
  /usr/local/pkg/perl/man
  /usr/local/share/man
  /usr/man
  /usr/share/man
  $manpath
)
infopath=(
  /usr/local/share/info
  /usr/share/info
  $infopath
)
path=(
  $HOME/.local/bin
  $HOME/.zplug/bin
  $HOME/bin
  /usr/local/bin
  /usr/bin
  $path
)

# create automatically virtualenv
_virtualenv_auto_activate() {
    if [ -d "venv" ]; then
        # check if already activated, avoids redundant activating
        if [ "$VIRTUAL_ENV" != "$(pwd -P)/venv" ]; then
            export _VENV_NAME=${$(pwd):t}
            echo Activating virtualenv \"$_VENV_NAME\"...
            export VIRTUAL_ENV_DISABLE_PROMPT=1
            source venv/bin/activate
        fi
    fi
}

# quick find by filename
qf (){
  if [ "$1" != "" ] && [ -"$2" != "" ]; then
    find $1 -name $2 2>/dev/null
  else
    echo "usage: qf path filename"
  fi
}

# generate random password
randpwd () { 
  if [ "$1" != "" ]; then
    gpg --gen-random --armor 1 $1
  else
    echo "usage: randpwd passlength"
  fi
}
# remove duplicated lines without sort
removeduplicates () { 
  if [ "$1" != "" ]; then
    awk '!x[$0]++' $1
  else
    echo "usage: removeduplicates filename"
  fi
}

# year calendar or current month
calendar () { 
  if [ "$1" != "" ]; then
    paste <(cal -y $1) | expand -t70
    read
  else
    cal
    read
  fi
}

# simple counter
beep() {
    local __timer=0
    [[ -n "$1" ]] && __timer=$1
    until [[ $__timer = 0 ]]; do
        printf "  T minus $__timer     \r"
        __timer=$((__timer - 1))
        sleep 1
    done
    echo '- BEEP! -    \a\r'
}

# lazypack
cd() { builtin cd "$@"; ls -lahF --color=auto; }

edit() { sudo subl3 "$@"; }

greppy() { grep -n "$1" *.py; }

mcd () { mkdir -p "$1" && cd "$1"; }

myps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

zipf () { zip -r "$1".zip "$1" ; }

fpid () { lsof -t -c "$@" ; }               # find pid of process

ff () { /usr/bin/find . -name "$@" ; }      # find file under the current directory

ffs () { /usr/bin/find . -name "$@"'*' ; }  # find file whose name starts with a given string

ffe () { /usr/bin/find . -name '*'"$@" ; }  # find file whose name ends with a given string

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

ii() {
    echo "# hostname: ${RED}$HOST"
    echo "# kernel:$NC " ; uname -a
    echo "# users logged on:$NC " ; w -h
    echo "# current date :$NC " ; date
    echo "# machine stats :$NC " ; uptime
    echo "# public facing IP Address :$NC " ; curl ipinfo.io/ip
}

# nullpointer url shortener
short() { curl -F"shorten=$*" https://0x0.st }

httpHeaders () { /usr/bin/curl -I -L $@ ; }

httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

json_post() {
  url=$1
  method=$2
  json=$3
  curl -v -H "Accept: application/json" -H "Content-type: application/json" -X ${method} -d ${json} ${url}
}

# git rebase -i
grbi() {
  if [ "$1" -gt 0 ]; then
    git rebase -i "HEAD~${1}"
  else
    echo "usage: grbi n\n  (n is number greater then 0)"
  fi
}

bqj() {
  local job_id=$1
  shift
  bq --format=json show -j $job_id | jq $@
}

# read markdown files like manpages
md() { pandoc -s -f markdown -t man "$*" | man -l - }

# colorized less
l() { pygmentize -O style=sourcerer -f console256 -g $1 | less -r }

# colorized cat
c() {
  for file in "$@"
  do
    pygmentize -O style=sourcerer -f console256 -g "$file" 
  done
}

dls () {
 # directory LS
 echo `ls -l | grep "^d" | awk '{ print $9 }' | tr -d "/"`
}

dgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    grep -iR "$@" * | grep -v "Binary"
}

dfgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    # and returns only unique filenames
    grep -iR "$@" * | grep -v "Binary" | sed 's/:/ /g' | awk '{ print $1 }' | sort | uniq
}

psgrep() {
    if [ ! -z $1 ] ; then
        echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}

if type hub > /dev/null 2>&1; then
  function git() {
    hub "$@"
  }
fi

# colors for permissions
if [[ "$EUID" -ne "0" ]]
then  # if user is not root
  USER_LEVEL="%F{cyan}"
else # root!
  USER_LEVEL="%F{red}"
fi

# 環境個別設定を読み込む (.zshenv.local)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
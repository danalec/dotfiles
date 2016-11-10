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
# last modified : 2016-11-10
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# 環境変数
#export LANG=ja_JP.UTF-8         # 日本語環境(ja_JP.UTF-8)
#export LANG=pt-BR.UTF-8         # Português-Brasileiro(pt-BR.UTF-8)
export LANG="en_US.UTF-8"

# グローバル変数
export BROWSER="chromium"
export EDITOR='nvim'
export GIT_EDITOR='nvim'
export IMAGEVIEWER="gthumb"
export PAGER='less'
export VISUAL='nvim'

export XAUTHORITY="$HOME/.Xauthority"
export SSH_KEY_PATH="~/.ssh/id_rsa"
export DISPLAY=:0
export KEYTIMEOUT=1   # vi mode

if [ -f "$HOME/.pythonrc.py" ]; then
  export PYTHONSTARTUP="$HOME/.pythonrc.py"
fi

# ホストネーム
if [ -x /bin/hostname ]; then
    export HOST=`hostname`
fi;
export host=`echo $HOST | sed -e 's/\..*//'`

# リモートから起動するコマンド用の環境変数を設定(必要なら)
export RSYNC_RSH=ssh
export CVS_RSH=ssh

# デフォルトのブロック・サイズのセット (ls, df, du)
export BLOCKSIZE=1k 

# misc
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='💡 '

# 径路
# ensure path arrays do not contain duplicates
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# check if npm is installed, if yes make -g install location in user directory
if type npm > /dev/null; then
  export NPM_PACKAGES="$HOME/.npm-packages"
  export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
  path=(
    $NPM_PACKAGES/bin
    $path
  )
  manpath='$NPM_PACKAGES/share/man'
fi

# check if ruby-gem is installed, if yes then import it to PATH
if type gem > /dev/null; then
  export GEM_HOME="$HOME/.gem"
  path=(
    $GEM_HOME/ruby/*/bin
    $path
  )
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

# 環境個別設定を読み込む (.zshenv.local)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
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
# last modified : 2016-11-14
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# if $ZDOTDIR is not set, force $HOME
if [ -z "$ZDOTDIR" ]; then
  ZDOTDIR="$HOME"
fi

#
# 径路
#
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
  manpath="$NPM_PACKAGES/share/man"
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

# check if go is present
if [ -f "/usr/bin/go" ]; then
  export GOPATH=~/go
  path=(
    $GOPATH/bin
    $path
  )
fi

# check if pythonrc is present
if [ -f "$HOME/.pythonrc.py" ]; then
  export PYTHONSTARTUP="$HOME/.pythonrc.py"
fi

# set tips text
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='💡 '

# 環境個別設定を読み込む
#(.zshenv.local)
if [ -f "$ZDOTDIR/.zshenv.local" ]; then
  source "$ZDOTDIR/.zshenv.local"
fi
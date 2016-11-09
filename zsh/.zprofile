#                                 .d888d8b888         
#                                d88P" Y8P888         
#                                888      888         
# 8888888888888b. 888d888 .d88b. 888888888888 .d88b.  
#    d88P 888 "88b888P"  d88""88b888   888888d8P  Y8b 
#   d88P  888  888888    888  888888   88888888888888 
#  d88P   888 d88P888    Y88..88P888   888888Y8b.     
# 8888888888888P" 888     "Y88P" 888   888888 "Y8888  
#         888                                         
#         888                                         
#         888                                         
# 
# ░ author ░ Dan Alec <danalec@gmail.com>
# ░  code  ░ https://github.com/danalec/dotfiles
#
# ~danalec/.zprofile
# last modified : 2016-11-09
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# X11自動スタート
if [ -z "$DISPLAY" ]; then
  case "$(fgconsole)" in
    1)
      [ -f "$HOME/.xinitrc" ] && exec startx
      ;;
    2)
      [ -f "/usr/bin/sway" ] && exec sway
      ;;
  esac
fi

# 環境個別設定を読み込む (.zprofile.local)
#if [ -f "$HOME/.zprofile.local" ]; then
#  source "$HOME/.zprofile.local"
#fi
#         888                d8b         
#         888                Y8P         
#         888                            
# 88888888888 .d88b.  .d88b. 88888888b.  
#    d88P 888d88""88bd88P"88b888888 "88b 
#   d88P  888888  888888  888888888  888 
#  d88P   888Y88..88PY88b 888888888  888 
# 88888888888 "Y88P"  "Y88888888888  888 
#                         888            
#                    Y8b d88P            
#                     "Y88P"             
# 
# ░ author ░ Dan Alec <danalec@gmail.com>
# ░  code  ░ https://github.com/danalec/dotfiles
#
# ~danalec/.zlogin
# last modified : 2016-11-10
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

# バックグラウンドで現在のセッションには影響しないコードを実行します。
{
  # 起動速度を上げるために完了ダンプをコンパイルします。
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# X11自動スタート
if [ -z "$DISPLAY" ] && [ -f "$XINITRC" ]; then
  case "$XDG_VTNR" in
    1)
      exec startx "$XINITRC" i3
      ;;
    2)
      exec startx "$XINITRC" gnome
      ;;
  esac
fi
#                             ████ ██        
#                            ░██░ ░░   █████ 
#  █████   ██████  ███████  ██████ ██ ██░░░██
# ██░░░██ ██░░░░██░░██░░░██░░░██░ ░██░██  ░██
#░██  ░░ ░██   ░██ ░██  ░██  ░██  ░██░░██████
#░██   ██░██   ░██ ░██  ░██  ░██  ░██ ░░░░░██
#░░█████ ░░██████  ███  ░██  ░██  ░██  █████ 
# ░░░░░   ░░░░░░  ░░░   ░░   ░░   ░░  ░░░░░  
#
# ░ author ░ Dan Alec <danalec@gmail.com>
# ░  code  ░ https://github.com/danalec/dotfiles
#
# ~danalec/.config/i3pystatus/config.py
# last modified : 2016-11-09
#
#█▓▒░ 修正、改変、再配布何でも可 ░▒▓█

from i3pystatus import Status, battery
from i3pystatus.updates import pacman, cower


def make_bar(percentage):
    """Modified function make_bar to substitute the original one"""
    bars = ['', '', '', '', '']
    base = 100 / (len(bars) - 1)
    index = round(percentage / base)
    return bars[index]


# inject it in battery module, so it will display unicode icons instead
# of the (ugly) default bars
battery.make_bar = make_bar
status = Status()

#status.register("mail",
#    email_client="/usr/local/bin/mutt",
#    format=": {unread}",
#    format_plural=": {unread}",
#    color_unread="#00FFFF",
#    backends=[
#        imap.IMAP(
             # port and ssl are the defaults
#             host="localhost", port=11111, username="danalec", password="XXXXXXXXXXXX"
#            )
#])

# show updates in pacman/aur
status.register(
    "updates",
    format=" {Pacman}/{Cower}",
    backends=[pacman.Pacman(), cower.Cower()],
    on_leftclick="""termite -e 'zsh -c "pacaur --noconfirm --noedit -Syu && read"'""",
    on_upscroll=None,
    on_downscroll=None,
)

# show clock
status.register(
    "clock",
    #format=[" %H:%M:%S", " %a X%d/%m"],
    format=[" %H:%M:%S", " %a %m/%d"],
    #on_leftclick="""termite -e 'zsh -c "calendar 2017"'""",
    on_leftclick="open https://calendar.google.com/calendar/",
    on_rightclick=None,
    on_upscroll="scroll_format",
    on_downscroll="scroll_format",
)

# show/change current keyboard layout
status.register(
    "xkblayout",
    format="  {name}",
    layouts=["us intl","br"],
)

# show/change volume using PA
status.register(
    "pulseaudio",
    format=" {volume}%",
    format_muted=" Mute",
    on_leftclick="pavucontrol",
)

# show/control screen brightness
status.register(
    "backlight",
    format=" {percentage}%",
    on_leftclick="exec xbacklight set 100",
    on_rightclick="exec xbacklight set 70",
)

# show/control screen brightness
status.register(
    "redshift",
    format_inhibit=["", ""],
)

# show battery status
status.register(
    battery,
    format="{bar} {percentage:.0f}%[ {remaining}][ {status}]",
    interval=5,
    alert_percentage=10,
    status={
        "CHR": "",
        "DPL": "",
        "DIS": "",
        "FULL": "",
    },
    on_leftclick=None,
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None,
)

# show disk available space
status.register(
    "disk",
    format=" {avail:.1f}G",
    path="/",
    on_leftclick=None,
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None,
)

# show available memory
status.register(
    "mem",
    format=" {avail_mem}G",
    warn_percentage=70,
    alert_percentage=90,
    divisor=1024**3,
    on_leftclick=None,
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None,
)

# show cpu usage
status.register(
    "load",
    format=" {avg1} {avg5} {avg15}",
    interval=5,
    on_leftclick="termite -e 'htop'",
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None,
)

# show CPU temperature
status.register(
    "temp",
    format=" {temp:.0f}°C",
    file="/sys/class/thermal/thermal_zone1/temp",
    alert_temp=70,
    on_leftclick=None,
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None,
)

# show network speed
status.register(
    "network",
    format_up="[ {essid} \[{quality}%\] ] {bytes_recv}K  {bytes_sent}K",
    format_down=" {interface}",
    interface="enp3s0",
    next_if_down=True,
    on_leftclick="termite -e 'sudo nmtui'",
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None,
)

# show current music info
player_format = '{status} [{artist} - {title} \[{song_length}\]]'
player_status = {
    'play': '',
    'pause': '',
    'stop': '',
}

status.register(
    "now_playing",
    format=player_format,
    status=player_status,
    on_leftclick="playerctl play-pause",
    on_rightclick="playerctl next",
    on_upscroll=None,
    on_downscroll=None,
)

status.register(
    "mpd",
    format=player_format,
    status=player_status,
    hide_inactive=True,
    on_upscroll=None,
    on_downscroll=None,
)

status.run()

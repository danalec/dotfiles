# Arch Linux Installation Cheatsheet (pt_BR)

por [Dan Alec](https://twitter.com/danalec) ([danalec@gmail.com](mailto:danalec@gmail.com)) // atualizado sempre que houver necessidade
⠀
 ## conteúdo
 - [introdução](#introdução)
 - [parte 0: instalador](#instalador)
 - [parte 1: bootando o live](#parte1)
 - [parte 2: instalando programas](#parte2)
 - [parte 3: economize tempo](#parte3)⠀
 - [parte 4: instalando programas](#parte4)
 - [parte 5: instalando mais programas](#parte5)
 - [parte 6: instalando mais e mais programas](#parte6)
 - [parte 7: instalando mais e mais e mais programas](#parte7)
 - [parte 8: repositórios adicionais](#parte8)

 - [archstrike](#archstrike)
 - [blackarch](#blackarch)

 - [hdparm](#hdparm)
 - [limpeza](#limpeza)

⠀
----------
## introdução
<a name="introdução"></a>

usuários familiarizados com o [Archlinux Wiki Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide) poderão utilizar este resumo para um 
  **fresh install com [btrfs](https://wiki.archlinux.org/index.php/Btrfs) [criptografado](https://wiki.archlinux.org/index.php/Dm-crypt) e [swap sem suporte a suspend](https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption#Without_suspend-to-disk_support)**.


o processo de instalação, mantém a instalação prévia do Microsoft Windows 10 e o método de cópia do boot utilizado, resulta numa instalação totalmente compatível para Insiders e possíveis atualizações futuras.
 
caso queira instalar a partir de uma instalação prévia (outra distro) e quiser manter arquivos, este guia não serve pra nada. mas graças à comunidade existe [outro guia](https://wiki.archlinux.org/index.php/Install_from_existing_Linux).

⠀
----------
## parte 0: instalador
<a name="instalador"></a>
item necessário: um pendrive (minimo 4GB) ou dispositivo com [DriveDroid](https://play.google.com/store/apps/details?id=com.softwarebakery.drivedroid&hl=en)

download necessário: [imagem ISO do Arch Linux](https://www.archlinux.org/download/)

- para usuário windows, utilize [Rufus](http://rufus.akeo.ie/)

- para usuário linux: 
`dd if=archlinux.img of=/dev/sdX bs=16M && sync`

lembrando que para listar os discos lógicos:
`lsblk -Sp`

⠀
----------
## parte 1: bootando o live
<a name="parte1"></a>
conectando: `dhcpcd enp3s0`
##### para wifi: `wifi-menu`

⠀
##### vamo listar os discos lógicos:`lsblk -Sp`

⠀
##### vamo fatiar o bolo com: `cfdisk`

###### meu flango ficou assim (dualboot w10-archlinux):
> ##### /dev/sda1 450M # win10 recovery
> ##### /dev/sda2 100M # win10 boot ef00
> ##### /dev/sda3 16M # win10 reserved
> ##### /dev/sda4 130G # win10
> ##### /dev/sda5 500M # boot ef00
> ##### /dev/sda6 97.9G # / 8300
> ##### /dev/sda7 4G # swap

##### bora checar novamente como ficou: `fdisk -l /dev/sda`
⠀
##### lembrando que o /dev/sda5 será a partição de boot e deverá ser obrigatoriamente **ef00**
utilize o gdisk para modificar a flag

⠀
##### vamos criar os containers transparentes
`cryptsetup luksFormat /dev/sda6`

`cryptsetup -d /dev/urandom create swap /dev/sda7`

⠀
##### vamos dar nome e abrir os containers
`cryptsetup --type luks open /dev/sda6 root`

⠀
##### formatar
`mkfs.fat -F32 /dev/sda5`

`mkfs.btrfs -L "Arch Linux" /dev/mapper/root`

`mkswap -f /dev/mapper/swap -v1 -L "swap"`

⠀
##### e montar tudo
`mount -o defaults,relatime,discard,ssd /dev/mapper/root /mnt`

⠀
##### criar algumas pastas que faltaram
`mkdir /mnt/home`

`mkdir /mnt/boot`

⠀
##### não se esqueça de montar o /boot
`mount /dev/sda5 /mnt/boot`

⠀
##### escolhendo os espelhos BR
`cd /etc/pacman.d `

`wget "https://archlinux.org/mirrorlist/?country=BR"`

`mv index.html?country=BR mirrorlist.b`

`sed -i 's/^#//' mirrorlist.b`

`rankmirrors -n 6 mirrorlist.b > mirrorlist`

⠀
##### vamos colocar o arch
`pacstrap /mnt base base-devel`

⠀
##### edite o pacman.conf `nano /etc/pacman.conf` e
descomente: [multilib] e seu endereço

descomente: Color;

adicione numa nova linha: ILoveCandy

⠀
##### copiando o que já fizemos para o disco da máquina
`cp -f /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist`

`cp -f /etc/pacman.conf /mnt/etc/pacman.conf`

⠀
##### não esqueça de salvar as tabela das partições que você montou
`genfstab -U -p /mnt >> /mnt/etc/fstab`

⠀
##### agora sim, podemos trocar nosso ambiente root aparente
`arch-chroot /mnt`

⠀
##### se tiver usando btrfs já instala:
`pacman -S btrfs-progs snapper`

⠀
##### selecione as línguas e gera o  locale
`nano /etc/locale.gen`

`locale-gen`

⠀
##### configure o  local
`ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime`

⠀
##### agora ajuste o  relógio
`hwclock --systohc --localtime`

⠀
##### dá o nome pro teu  flango
`echo flango > /etc/hostname`

⠀
##### obviamente nao esqueça da senha do root
`passwd`

⠀
##### aproveita e crie um username e já coloca senha, já bota zsh como padrão
`useradd -m -g users -G wheel,storage,power -s /bin/zsh danalec`

`passwd danalec`

⠀
##### vamos de sudo
`pacman -S sudo`

⠀
##### agora configurar é só: `EDITOR=nano visudo`
##### descomenta o `#wheel` e logo na linha de baixo adicione: `Defaults rootpw` (para que a senha do sudo seja a mesma do root, não do usuário).

⠀
##### agora vamos editar o fstab: `nano /etc/fstab`
##### dê preferência nos UUID e para isso utilize:
`blkid /dev/mapper/root`

`blkid /dev/sda5`
⠀

> ##### # /dev/mapper/root
> UUID=938b6700-d1ad-4556-a0b0-0c2e6554286d	/      	btrfs     rw,relatime,ssd,discard,space_cache,subvolid=5,subvol=/	0 0
> 
> ##### # /dev/sda5
> UUID=6BC7-00BD     /boot  	vfat    rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro	0 2
> 
> /dev/mapper/swap none swap defaults,discard 0 0

⠀
##### agora para o crypttab: `nano /etc/crypttab`
##### utilizaremos o PARTUUID: `blkid /dev/sda7`
> swap	PARTUUID=86a7f104-bc8a-40c4-9c58-b50a5e913c1c	/dev/urandom	swap,cipher=aes-cbc-essiv:sha256,size=256

⠀
##### agora vamos precisar do bootloader
`bootctl install`

⠀
##### se for intel, coloca isso!
`pacman -S intel-ucode`

⠀
##### agora vamos editar o mkinitcpio: `nano /etc/mkinitcpio.conf`
adicione: `MODULES="lz4 lz4_compress"`
##### se usa nvidia ou noveuau, pode colocar no **MODULES**
⠀
##### em **HOOKS**:
##### coloque btrfs depois de udev
##### encrypt antes de filesystems
##### vai ficar algo tipo assim: `HOOKS="base udev btrfs autodetect modconf block encrypt filesystems keyboard fsck"`
##### salve e: `mkinitcpio -p linux`

⠀
##### agora vamos criar um arch.conf pro bootctl: `nano /boot/loader/entries/arch.conf`

note que: `cryptdevice=/dev/sda6` e `root=/dev/mapper/root`
> ##### title Arch Linux
> ##### linux /vmlinuz-linux
> ##### initrd /intel-ucode.img
> ##### initrd /initramfs-linux.img
> ##### options cryptdevice=UUID=bbe334f1-f9a9-455e-8e76-1425184d70cb:root root=UUID="938b6700-d1ad-4556-a0b0-0c2e6554286d" rw
> ##### options sysrq_always_enabled=1
> ##### options zswap.enabled=1 zswap.compressor=lz4

⠀
##### agora vamos instalar uns pacotes básicos
`pacman --noconfirm -S iw wpa_supplicant dialog wireless_tools networkmanager`

se precisar desligar ethernet: `$ sudo systemctl disable dhcpcd@enp3s0.service`

se precisar desligar wifi: `$ sudo systemctl disable netctl-auto@wlp4s0.service`

##### mas já deixa ligado
`systemctl enable NetworkManager.service`

⠀
##### atenção usuários nvidia: tem que instalar antes de bootar: `pacman -S nvidia`

⠀
##### ou o driver da comunidade: `pacman -S xf86-video-nouveau mesa-vdpau libva-mesa-driver`

⠀
##### é usuário SLI ou CrossFire? edite: /etc/modprobe.d/acpi.conf
> ##### video.allow_duplicates=1
> ##### acpi_enforce_resources=lax

⠀
##### antes de remover o pendrive e reboot, deixe já preparado:
`pacman --noconfirm -S zsh wget curl git vim neovim`

⠀
##### é isso ae, vamos sair do chroot
`exit`

⠀
##### reinicialize
`reboot`

----------
## parte 2: bootando pela primeira vez a máquina
<a name="parte2"></a>
agora, o símbolo **$** irá denotar a necessidade de previlégio elevado e **#** a ausência.

##### vamos instalar as dependências do cower e pacaur antes, para poder usá-los:
`$ sudo pacman --noconfirm -S yajl expac`

#####  bora pegar os arquivos do cower
`# gpg --recv-keys 1EB2638FF56C0C53 && git clone https://aur.archlinux.org/cower.git`

#####  agora vamos montar e instalar manualmente
`# cd cower && makepkg`

`$ sudo pacman -U cower-*.pkg.tar.xz`

##### já vamo baixar o pacaur, usando o cower:
`# cower -d pacaur`

##### montamos o pacaur e instalamos:
`# cd pacaur && makepkg`

`# sudo pacman -U pacaur-*.pkg.tar.xz`

⠀
----------
## parte 3: economize tempo
<a name="parte3"></a>
note que iremos usar bastante alguns comandos como: `sudo pacman --noconfirm -S`

tome a liberdade de criar um alias: `alias pac="sudo pacman --noconfirm -S "` para que se instale diretamente como o exemplo: `pac tmux`

ou caso queira clonar meu dotfiles, inclua os meus aliases de zsh:
`git clone https://github.com/danalec/dotfiles ~/dotfiles`

`cd dotfiles && stow zsh`

para adicionar a configuração do pacman: `sudo stow pacman -t /`

(e inicie uma sessão zsh):`/bin/zsh` ou altere a sessão do usuário: `chsh -s $(which zsh)`

utilize como o exemplo `apacaur stow` e `apacman mc`
⠀
----------
## parte 4: moar!
<a name="parte4"></a>
##### tá faltando um montão de programa, temos ainda que instalar vários:
###### base packages

`$ sudo pacman --noconfirm -S stow compton rsync unzip unrar tmux tree lsof lha mc`

`$ sudo pacman --noconfirm -S pygmentize lm_sensors xclip hub termite htop psutils ccze`

`# pacaur --noconfirm --noedit -S sux playerctl dtrx pcmanfm-gtk3-git`

⠀
##### agora vamos escolher os WM (Window Manager, aka interface gráfica):
- caso você escolha (instalar o gdm), não precisará instalar o xorg-server:

`$ sudo pacman --noconfirm -S gdm gnome-tweak-tool gnome-control-center gvfs gvfs-mtp xorg-xprop xorg-xbacklight xorg-xkill`

`$ sudo systemctl enable gdm.service`

se você quer continuar instalando utilitários do gnome, aqui vão alguns úteis:

`$ pacaur --noconfirm -S chrome-gnome-shell-git`

instale também o: [Gnome Extension](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=en) e acesse https://extensions.gnome.org para adicionar as extensões ao gnome desktop

⠀
obs: existe também a opção de utilizar o sway que é o i3 escrito para wayland:

`$ sudo pacman --noconfirm -S sway dmenu`

⠀
- ##### caso você escolha (não instalar o gdm) e **economizar 600MB de RAM**, iremos precisar do xorg-server:

`$ sudo pacman -S xorg-server xorg-xauth`

⠀
##### vamos também adicionar suporte a partições NTFS e exFAT:
`$ sudo pacman --noconfirm -S ntfs-3g exfat-utils`

⠀
##### para que sua partição do Windows seja detectada, alguns arquivos do /dev/sda2 devem ser copiados para /boot:

`$ sudo mkdir /mnt/winboot && sudo mount /dev/sda2 /mnt/winboot`

`$ sudo cp -nr /mnt/winboot/* /boot/`

lembrando pressionar a tecla F8 para visualizar as opções no boot

⠀
##### e instalar um navegador:
`pacman --noconfirm -S chromium`

se você usa netflix, precisará: `pacaur --noconfirm --noedit -S chromium-widevine`

⠀
##### agora vamos instalar o que falta para meu dotfiles:
`$ sudo pacman -S i3-wm scrot nitrogen imagemagick ffmpeg dunst`

`# pacaur --noconfirm --noedit -S ranger-git redshift-gtk-git dunstify pamixer`


`# pacaur --noconfirm --noedit -S xcwd-git xdg-user-dirs xdg-utils xdg-user-dirs-gtk`

todo: `ln -s ~/.config/mimeapps.list ~/.local/share/applications/mimeapps.list`

i3-config-wizard



para gerar as pastas:

`# LC_ALL=C xdg-user-dirs-update`

para corrigir o controle do brightness:

para nvidia
`sudo chmod 777 /sys/class/backlight/nv_backlight/brightness`
ou para intel
`sudo chmod 777 /sys/class/backlight/acpi_video0/brightness`
⠀
##### vamos evitar tofus (retângulos vazios, caracteres não disponíveis)

`$ sudo pacman --noconfirm -S noto-fonts ttf-liberation wqy-zenhei wqy-microhei wqy-microhei-lite`

`# pacaur --noconfirm --noedit -S powerline-fonts ttf-hack ttf-font-awesome ttf-roboto`

extras: `# pacaur --noconfirm --noedit -S font-mathematica ttf-monapo ttf-liberation`

⠀
##### painel de volume completão
`# pacaur --noconfirm --noedit -S pavucontrol`


##### ladspa : como normalizar o som
`# pacaur --noconfirm --noedit -S ladspa swh-plugins`

edite ~/.config/pulse/default.pa

`.nofail
.include /etc/pulse/default.pa
load-module module-ladspa-sink  sink_name=ladspa_sink  plugin=dyson_compress_1403  label=dysonCompress  control=0,1,0.5,0.99
load-module module-ladspa-sink  sink_name=ladspa_normalized  master=ladspa_sink  plugin=fast_lookahead_limiter_1913  label=fastLookaheadLimiter  control=10,0,0.8
set-default-sink ladspa_normalized`

⠀
##### acpi para ler algumas informações da máquina
`$ sudo pacman --noconfirm -S acpi`

##### vamos remover porque nunca mais iremos usar (pelo menos eu não quero)
`$ sudo pacman -Rns nano vi`

⠀
##### mpv e seus amiguinhos:
`# pacaur --noconfirm --noedit -S mpv-build-git youtube-dl-git youtube-mpv-git youtube-upload-git`

⠀
###### kodi é cheio de plugins legais
`# pacaur --noconfirm --noedit -S kodi`

⠀
##### visualizador de imagens que adoro
`# pacaur --noconfirm --noedit -S gthumb`

⠀
##### automatizador de teclas 
`# pacaur --noconfirm --noedit -S autokey-py3`

⠀
##### extrator de áudio de vários serviços de vídeo online
`# pacaur --noconfirm --noedit -S 4kyoutubetomp3`

⠀
###### esse downloader eh da hora, eh uploader tb
`# pacaur --noconfirm --noedit -S plowshare`

⠀
###### método alternativo para baixar APK de android no google play:
`# pacaur --noconfirm --noedit -S raccoon`

⠀
###### app launcher legal para gnome (é meio parecido com alfred)
`# pacaur --noconfirm --noedit -S mutate-git`

###### tem esse também:
`# pacaur --noconfirm --noedit -S albert`

⠀
###### leitor de pdf, djvu, postscript levinho (chrome é melhor pra pdf)
`# pacaur --noconfirm --noedit -S zathura`

⠀
###### rtorrent
`# pacaur --noconfirm --noedit -S rtorrent-vi-color rtorrent-systemd`

`# pacaur --noedit --noconfirm -S rtorrent-color rutorrent-git`

⠀
###### mas na falta de saco pra configurar, vamos usar o deluge mesmo
`# pacaur --noconfirm --noedit -S deluge-git`

⠀
##### tradutor e calculadora commandline
`# pacaur --noconfirm --noedit -S translate-git wcalc`

⠀
##### inúteis mas legais
`# pacaur --noconfirm --noedit -S sl figlet cowsay ponysay lolcat toilet cmatrix figlet toilet-fonts figlet-fonts`

⠀
____________
<a name="steam"></a>
## /r/PCMASTERRACE
`# pacaur --noconfirm --noedit -S steam-fonts`

`$ sudo pacman --noconfirm -S lib32-alsa-plugins lib32-curl steam-native-runtime steam`
⠀

qualquer dúvida, [leia isto](https://wiki.archlinux.org/index.php/Steam/Troubleshooting#Native_runtime)

outros utilitários pro steam:

`# pacaur --noconfirm --noedit -S asf steam-idle-master-git`

⠀
###### para quem usa razer, este é bem útil
`# gpg --recv-keys 5FB027474203454C && pacaur --noconfirm --noedit -S razercfg`

⠀
<a name="parte5"></a>
##### lxappearance 
`# pacaur --noconfirm --noedit -S lxappearance-gtk3`

⠀
##### gtk2 theme changer
`# pacaur --noconfirm --noedit -S gtk-chtheme`

⠀
##### [adwaita dark gtk2 gtk3](https://github.com/axxapy/Adwaita-dark-gtk2)
`# cd /usr/share/themes`

`$ sudo git clone https://github.com/axxapy/Adwaita-dark-gtk2.git Adwaita-dark`

`# cd /usr/share/themes/Adwaita`

`$ sudo cp gtk-2.0 gtk-2.0-bkp`

`$ sudo cp -R ../Adwaita-dark/gtk-2.0 ./`

⠀
##### paper icon theme
`# pacaur --noconfirm --noedit -S paper-icon-theme-git`
`# pacaur --noconfirm --noedit -S paper-icon-theme-git-latest`

⠀
##### adwaita para qt4
`# pacaur --noconfirm --noedit -S adwaita-qt4`

##### qt5ct qt5gtk2
`# pacaur --noconfirm --noedit -S qt5ct qt5gtk2`
⠀
##### powerpill

`# gpg --recv-keys 1D1F0DC78F173680`

`# pacaur --noconfirm --noedit -S powerpill`

⠀
##### extratores adicionais
`# sudo pacman --noconfirm -S p7zip unace lrzip`

⠀
##### este wrapper de lixeira é excelente:
`# gpg --recv-keys 50F33E2E5B0C3D900424ABE89BDCF497A4BBCC7F`

`$ sudo pacman-key --refresh-keys`

`# pacaur --noconfirm --noedit -S trash-cli`

⠀
##### vamos colocar numlock automaticamente
`$ sudo pacman -S xorg-xmodmap xkeycaps`

`# pacaur --noconfirm --noedit -S autonumlock`

[mais informações sobre numlock](https://wiki.archlinux.org/index.php/Activating_Numlock_on_Bootup)

###### se você usa gdm:

`$ sudo pacman --noconfirm -S numlockx`

###### edite /etc/gdm/Init/Default e coloca antes do exit
> ##### if [ -x /usr/bin/numlockx ]; then
> ##### /usr/bin/numlockx on
> ##### fi

`# pacaur --noconfirm --noedit -S systemd-numlockontty`

e para ativar

`$ sudo systemctl enable numLockOnTty`

⠀
##### ibus para os poliglotas

`$ sudo pacman --noconfirm -S ibus`

⠀
##### [video editors](https://wiki.archlinux.org/index.php/List_of_applications/Multimedia)
###### não testei nenhum, tou aqui listando pra posterioridade

`$ sudo pacman --noconfirm -S openshot`

`$ sudo pacman --noconfirm -S kdenlive`

`$ sudo pacman --noconfirm -S shotcut`

`$ sudo pacman --noconfirm -S pitivi`

`$ sudo pacman --noconfirm -S cinelerra-cv`

`# pacaur --noconfirm --noedit -S vlmc`

`# pacaur --noconfirm --noedit -S openmovieeditor`

⠀
____________
## + programas que provavelmente não te interessarão
<a name="parte6"></a>

##### ripgrep-simd (rust rustup)
`$ sudo pacman --noconfirm -S rust`
`# pacaur --noconfirm --noedit -S rustup-git`
`# rustup override set nightly`
`# pacaur --noconfirm --noedit -S ripgrep-simd`

⠀
##### sox (opusfile libmad) ecasound
`$ sudo pacman --noconfirm -S sox opusfile libmad ecasound`

⠀
##### meld
`$ sudo pacman --noconfirm -S meld`

⠀
##### sublime3
`# pacaur --noconfirm --noedit -S sublime-text-dev`

⠀
##### nginx
`# pacaur --noconfirm --noedit -S php php-fpm nginx ngxtop`

⠀
##### chromium-dev
`# gpg --recv-keys 702353E0F7E48EDB`
`# pacaur -S ncurses5-compat-libs`

⠀
##### net-tools and others
`$ sudo pacman --noconfirm -S openssh openssl net-tools mtr traceroute dnsutils whois nmap wavemon gnome-nettool sshfs proxychains-ng`

⠀
##### fail2ban
`$ sudo pacman --noconfirm -S fail2ban`

`$ sudo systemctl start fail2ban`

`$ sudo systemctl enable fail2ban`

⠀
##### dlang: dmd dcd dtools 
`$ sudo pacman --noconfirm -S dmd dcd dtools`

⠀
____________
## ...
<a name="parte7"></a>
#### recompilando o kernel
##### vamos pegar a assinatura do Linus Torvalds
`gpg --recv-keys 79BE3E4300411886`

⠀
###### linux-ck linux-ck-headers nvidia-ck
#####vamos precisar de mais uma outra assinatura
`gpg --recv-keys 38DBBDC86092693E`

`# pacaur --noconfirm --noedit -S linux-ck linux-ck-headers nvidia-ck`

`$ sudo nvim /boot/loader/entries/arch2.conf`

> ##### title Arch Linux-ck
> ##### linux /vmlinuz-linux-ck
> ##### initrd /intel-ucode.img
> ##### initrd /initramfs-linux-ck.img
> ##### options cryptdevice=UUID=bbe334f1-f9a9-455e-8e76-1425184d70cb:root root=UUID="938b6700-d1ad-4556-a0b0-0c2e6554286d" rw
> ##### options sysrq_always_enabled=1
> ##### options zswap.enabled=1 zswap.compressor=lz4

⠀
###### linux-lqx linux-lqx-headers linux-lqx-docs nvidia-lqx
###### `# pacaur --noconfirm --noedit -S linux-lqx linux-lqx-docs linux-lqx-headers nvidia-lqx`

###### `$ sudo nvim /boot/loader/entries/arch3.conf`

> ##### title Arch Linux-lqx
> ##### linux /vmlinuz-linux-lqx
> ##### initrd /intel-ucode.img
> ##### initrd /initramfs-linux-lqx.img
> ##### options cryptdevice=UUID=bbe334f1-f9a9-455e-8e76-1425184d70cb:root root=UUID="938b6700-d1ad-4556-a0b0-0c2e6554286d" rw
> ##### options sysrq_always_enabled=1
> ##### options zswap.enabled=1 zswap.compressor=lz4_compress

###### o controle de brightness do lqx tenta instalar automaticamente o **nvidiabl** porém a configuração é manual, [mais informações](https://wiki.archlinux.org/index.php/NVIDIA#Enabling_brightness_control): `# pacaur -S nvidiabl`

###### para inicializar o driver: `$ sudo modprobe nvidiabl`

###### `$ sudo systemctl mask systemd-backlight@backlight\:acpi_video0.service`

⠀
###### grsec: grsec-common linux-grsec linux-grsec-docs linux-grsec-headers nvidia-grsec acpi_call-grsec
⠀

##### Greg Kroah-Hartman (kernel stable)
`gpg --recv-keys 38DBBDC86092693E`
⠀
##### llvm
mantenha seu sistema atualizado antes de começar

`$ sudo pacman -Syu`

só para os corajosos
`# pacaur --noconfirm --noedit -S llvm-svn lib32-llvm-svn`

`# pacaur --noconfirm --noedit -S mesa-git lib32-mesa-git`

##### se você acha que o llvm-svn demora muito pra compilar (quase uma hora no meu sistema), o Kerberizer é mantenedor AUR (llvm-svn & lib32-llvm-svn) e possui um [repo não-oficial](https://wiki.archlinux.org/index.php/Unofficial_user_repositories#llvm-svn)

⠀
###### ferm

⠀
###### iptables

⠀
____________
<a name="sec"></a>
## Sec

<a name="archstrike"></a>
##### [archstrike](https://archstrike.org/wiki/setup)

`$ sudo nvim /etc/pacman.conf`
> ##### [archstrike]
> ##### Server = https://mirror.archstrike.org/$arch/$repo

`# pacman -Sg | grep archstrike`

`# pacman -Sgg | grep archstrike-`

⠀
<a name="blackarch"></a>
##### [blackarch](http://blackarch.org/downloads.html#install-repo)

###### dependancies: `$ sudo pacman -S php-pear`

`curl -O https://blackarch.org/strap.sh && sha1sum strap.sh`

`$ sudo ./strap.sh`

`$ sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u`

`$ sudo pacman -S blackarch` 

`$ sudo nvim /etc/pacman.conf`
> ##### [blackarch]
> ##### Server = http://arch.localmsp.org/blackarch//$repo/os/$arch

`$ sudo pacman-key --init`

`$ sudo pacman-key --populate archlinux`

`$ sudo pacman -Syy`

⠀

____________
## Limpeza
<a name="limpeza"></a>
##### faxina no pacman

`sudo pacman -Rsn $(pacman -Qdtq)`

`sudo pacman -Sc && sudo pacman-optimize`

⠀
____________

<a name="hdparm"></a>
##### diagnóstico com hdparm
info: `hdparm -I /dev/sda | more`

velocidade de leitura: `hdparm -t --direct /dev/sda`

velocidade de escrita: `sync;time bash -c "(dd if=/dev/zero of=bf bs=8k count=500000; sync)"`

hdd diagnóstico:`sudo smartctl --all /dev/sda2`

⠀

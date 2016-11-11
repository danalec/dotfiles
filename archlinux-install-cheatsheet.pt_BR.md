Arch Linux Installation Cheatsheet (pt_BR)
---------
por [Dan Alec](https://twitter.com/danalec) ([danalec@gmail.com](mailto:danalec@gmail.com))
⠀
# conteúdo
 - [introdução](#introdução)
 - [parte 0: instalador](#parte0)
 - [parte 1: bootando o live](#parte1)
 - [parte 2: instalando programas](#parte2)
 - [parte 3: economize tempo](#parte3)⠀
 - [parte 4: instalando mais programas](#parte4)


----------
# introdução<a name="introdução"></a>
 este guia foi escrito para guiar amigos familiarizados com [Archlinux Wiki Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide), para um **fresh install**.
 
 caso você queira instalar de uma instalação prévia do Linux (outra distro) e quiser manter seus arquivos, este guia não serve pra nada, portanto [clique aqui](https://wiki.archlinux.org/index.php/Install_from_existing_Linux).


----------
<a name="parte0"></a>
# parte 0: instalador

#### item necessário: um pendrive (minimo 4GB) ou dispositivo com [DriveDroid](https://play.google.com/store/apps/details?id=com.softwarebakery.drivedroid&hl=en)

⠀
#### download necessário: [imagem ISO do Arch Linux](https://www.archlinux.org/download/)

⠀
#### - para usuário windows, utilize [Rufus](http://rufus.akeo.ie/)

⠀
#### - para usuário linux: 
`dd if=archlinux.img of=/dev/sdX bs=16M && sync`

⠀
#### obs: lembrando que para listar os discos lógicos:
`lsblk -Sp`

⠀
----------
<a name="parte1"></a>
## parte 1: bootando o live

###### conectando: `dhcpcd enp3s0`
##### para wifi: `wifi-menu`

⠀
##### vamo listar os discos lógicos:`lsblk -Sp`

⠀
##### vamo fatiar o bolo com: `cfdisk`

⠀
###### meu flango ficou assim (dualboot w10-archlinux):
> ##### /dev/sda1 450M # win10 recovery
> ##### /dev/sda2 100M # win10 boot ef00
> ##### /dev/sda3 16M # win10 reserved
> ##### /dev/sda4 130G # win10
> ##### /dev/sda5 500M # boot ef00
> ##### /dev/sda6 97.9G # / 8300
> ##### /dev/sda7 4G # swap

###### bora checar novamente como ficou: `fdisk -l /dev/sda`
⠀
##### lembrando que o /dev/sda5 será a partição de boot
##### e deverá ser obrigatoriamente **ef00** (utilize o gdisk para modificar a flag)

⠀
##### vamos criar os containers transparentes
`cryptsetup luksFormat /dev/sda6`

`cryptsetup -d /dev/urandom create swap /dev/sda7`

⠀
##### vamos dar nome e abrir os containers
`cryptsetup --type luks open /dev/sda6 root`

⠀
##### vamos formatar
`mkfs.fat -F32 /dev/sda5`

`mkfs.btrfs -L "Arch Linux" /dev/mapper/root`

`mkswap -f /dev/mapper/swap -v1 -L "swap"`

⠀
##### vamos montar tudo
`mount -o defaults,relatime,discard,ssd,nodev,nosuid /dev/mapper/root /mnt`

⠀
##### criar algumas pastas que faltaram
`mkdir /mnt/home`

`mkdir /mnt/boot`

⠀
##### não se esqueça de montar o /boot
`mount /dev/sda5 /mnt/boot`

⠀
##### escolhendo os espelhos do BR
`cd /etc/pacman.d `

`wget "https://archlinux.org/mirrorlist/?country=BR"`

`mv index.html?country=BR mirrorlist.b`

`sed -i 's/^#//' mirrorlist.b`

`rankmirrors -n 6 mirrorlist.b > mirrorlist`

⠀
##### vamos colocar o arch
`pacstrap /mnt base base-devel`

⠀
##### copiando o que já fizemos para o disco da máquina
`cp -f /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist`

⠀
##### não esqueça de salvar as tabela das partições que você montou
`genfstab -U -p /mnt >> /mnt/etc/fstab`

⠀
##### agora sim, podemos trocar nosso ambiente root aparente
`arch-chroot /mnt`

⠀
#####  se tiver usando btrfs já instala:
`pacman -S btrfs-progs snapper`

⠀
#####  seleciona as línguas e gera o locale
`nano /etc/locale.gen`

`locale-gen`

⠀
#####  configura seu local
`ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime`

⠀
##### agora ajusta o relogio pra usar o relogio do sistema :D
`hwclock --systohc --localtime`

⠀
##### dá o nome pro teu flango
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
##### descomenta o `#wheel` e logo na linha de baixo adicione: `Defaults rootpw`

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
##### adicione: `MODULES="lz4 lz4_compress"`
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

##### e já deixa ligado
`systemctl enable NetworkManager.service`

⠀
##### atenção usuários nvidia: tem que instalar antes de bootar: `pacman -S nvidia`

⠀
##### ou o driver da comunidade: `pacman -S xf86-video-nouveau mesa-vdpau libva-mesa-driver`

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
<a name="parte2"></a>
## parte 2: bootando pela primeira vez a máquina

nessa altura do campeonato, o símbolo **$** irá denotar a necessidade de previlégio elevado e **#** a ausência.

##### vamos instalar as dependências do cower e pacaur antes, para poder usá-los:
`$ sudo pacman --noconfirm -S yajl expac`

#####  bora pegar os arquivos do cower
`# gpg --recv-keys 1EB2638FF56C0C53 && git clone https://aur.archlinux.org/cower.git`

#####  agora vamos montar e instalar manualmente
`# cd cower && makepkg`

`$ sudo pacman -U cower-*-x86_64.pkg.tar.xz`

##### já vamo baixar o pacaur, usando o cower:
`# cower -d pacaur`

##### montamos o pacaur e instalamos:
`# cd pacaur && makepkg`

`# sudo pacman -U pacaur-*-any.pkg.tar.xz`

⠀
----------
<a name="parte3"></a>
## parte 3: economize tempo

note que iremos usar bastante alguns comandos como `sudo pacman --noconfirm -S`

tome a liberdade de criar um alias: `alias pac="sudo pacman --noconfirm -S "` para que se instale diretamente como o exemplo: `pac tmux`

ou caso queira clonar meu dotfiles, inclua os meus aliases de zsh:
`git clone https://github.com/danalec/dotfiles`

`cd dotfiles && stow zsh`

(e inicie uma sessão zsh):`/bin/zsh`

e utilize como o exemplo `pacauru stow` e `pacaman mc`

⠀
----------
<a name="parte4"></a>
## parte 4: moar!
##### tá faltando um montão de programa, temos ainda que instalar vários:

`$ sudo pacman --noconfirm -S stow compton rsync unzip unrar tmux tree lsof lha mc`

`$ sudo pacman --noconfirm -S pygmentize lm_sensors xclip hub termite htop psutils`

`# pacaur --noconfirm --noedit -S sux playerctl dtrx pcmanfm-gtk3-git`

⠀
##### agora vamos escolher os WM (Window Manager, aka interface gráfica):
- caso você escolha (instalar o gdm), não precisará instalar o xorg-server:

`$ sudo pacman --noconfirm -S gdm gnome-tweak-tool gnome-control-center gvfs gvfs-mtp xorg-xprop`

`# sudo systemctl enable gdm.service`

se você quer continuar instalando utilitários do gnome, aqui vão alguns úteis:

`# pacaur --noconfirm -S chrome-gnome-shell-git`

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
`$ sudo pacman -S i3-wm scrot nitrogen imagemagick ffmpeg`

`# pacaur --noconfirm --noedit -S ranger-git redshift-gtk-git xcwd-git xdg-user-dirs`

para gerar as pastas:

`# LC_ALL=C xdg-user-dirs-update`

e para corrigir o controle do brightness:

`sudo chmod 777 /sys/class/backlight/nv_backlight/brightness`

⠀
##### vamos evitar tofus (retângulos vazios, caracteres não disponíveis)

`# pacaur --noconfirm -S powerline-fonts ttf-hack ttf-font-awesome`

`# pacaur --noconfirm -S font-mathematica ttf-monapo ttf-liberation`

`$ sudo pacman --noconfirm -S noto-fonts`

`$ sudo pacman --noconfirm -S ttf-liberation wqy-zenhei wqy-microhei wqy-microhei-lite`

⠀

##### painel de volume completão
`# pacaur --noconfirm --noedit -S pavucontrol`

⠀
____________
____________
    se você sobreviveu até aqui: parabéns!
                         a partir daqui é opcional...
____________
____________
⠀
##### não é necessário mas é delicioso:
`# pacaur --noconfirm -S mpv-build-git youtube-dl-git youtube-mpv-git youtube-upload-git`

⠀
###### kodi é mais outro player pra sua coleção, mas é delicioso
`pacaur --noconfirm --noedit -S kodi`

⠀
##### vamos remover porque nunca mais iremos usar (pelo menos eu não quero)
`$ sudo pacman -Rns nano vi`

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
##### este wrapper de lixeira é excelente:
`# gpg --recv-keys 50F33E2E5B0C3D900424ABE89BDCF497A4BBCC7F`

`$ sudo pacman-key --refresh-keys`

`# pacaur -S trash-cli`

⠀
##### vamos colocar numlock automaticamente
`$ sudo pacman -S xorg-xmodmap xkeycaps`

`# pacaur -S autonumlock`

⠀
###### esse downloader eh da hora, eh uploader tb
`# pacaur --noconfirm --noedit -S plowshare`

⠀
###### método alternativo para baixar APK de android no google play:
`# pacaur --noconfirm --noedit -S raccoon`

⠀
###### um app launcher legal para gnome
`# pacaur --noconfirm --noedit -S mutate-git`

⠀
###### rtorrent
`# pacaur --noconfirm --noedit -S rtorrent-vi-color rtorrent-systemd`

`# pacaur --noconfirm --noedit -S rutorrent-git`

⠀
###### mas na falta de saco pra configurar, vamos usar o deluge mesmo
`# pacaur --noconfirm --noedit -S deluge`

⠀
##### inúteis mas legais (reparou né?)
`# pacaur --noconfirm --noedit -S sl figlet cowsay ponysay lolcat toilet cmatrix figlet toilet-fonts figlet-fonts`

⠀
____________
##### /r/PCMASTERRACE
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
____________
____________
    aqui em diante está em manutenção, volte mais tarde :3
____________
____________
⠀
<a name="parte5"></a>
⠀
###### linux-ck linux-ck-headers nvidia-ck
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
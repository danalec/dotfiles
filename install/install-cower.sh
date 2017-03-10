#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl"

echo 'installing requirements'
sudo pacman --noconfirm -S yajl expac

echo 'necessary keys'
gpg --recv-keys 1EB2638FF56C0C53

echo 'creating temporary folder'
TMPCOWERDIR="${0##*/}-$$"
mkdir -v "/tmp/$TMPCOWERDIR"

echo 'cloning git'
git clone https://aur.archlinux.org/cower.git /tmp/$TMPCOWERDIR

echo 'makepkg'
cd /tmp/$TMPCOWERDIR
makepkg -si

#sudo pacman --noconfirm -U cower-*.pkg.tar.xz

echo 'cleaning temporary folder'
rm -rf /tmp/$TMPCOWERDIR
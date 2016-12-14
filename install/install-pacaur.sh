#!/bin/bash

echo 'creating temporary folder'
TMPPACAURDIR="${0##*/}-$$"
mkdir -v "/tmp/$TMPPACAURDIR"

echo 'cloning git'
git clone https://aur.archlinux.org/pacaur.git /tmp/$TMPPACAURDIR

echo 'makepkg'
cd /tmp/$TMPPACAURDIR
makepkg -si

#sudo pacman --noconfirm -U pacaur-*.pkg.tar.xz

echo 'cleaning temporary folder'
rm -rf /tmp/$TMPPACAURDIR
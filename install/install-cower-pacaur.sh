#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl"

sudo pacman --noconfirm -S yajl expac

gpg --keyserver pgp.mit.edu --recv-keys 487EACC08557AD082088DABA1EB2638FF56C0C53
gpg --recv-keys 1EB2638FF56C0C53

echo 'creating temporary folder'
TMPCOWERDIR="${0##*/}-$$"
mkdir -v "/tmp/$TMPCOWERDIR"
TMPPACAURDIR="${0##*/}-$$"
mkdir -v "/tmp/$TMPPACAURDIR"

echo 'downloading cower'
cd /tmp/$TMPCOWERDIR || exit 1
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz | tar xz

echo 'cower makepkg'
makepkg --syncdeps --install --noconfirm

echo 'downloading pacaur'
cd /tmp/$TMPPACAURDIR || exit 1
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz | tar xz

echo 'pacaur makepkg'
makepkg --syncdeps --install --noconfirm

echo 'cleaning temporary folder'
rm -rf /tmp/$TMPCOWERDIR
rm -rf /tmp/$TMPPACAURDIR
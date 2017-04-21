#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl"

sudo pacman --noconfirm -S yajl expac

gpg --keyserver pgp.mit.edu --recv-keys 487EACC08557AD082088DABA1EB2638FF56C0C53
gpg --keyserver pgp.mit.edu --recv-keys 1EB2638FF56C0C53

echo 'creating temporary folder'
TMPCOWERDIR="cower-$$"
mkdir -v "/tmp/$TMPCOWERDIR"
TMPPACAURDIR="pacaur-$$"
mkdir -v "/tmp/$TMPPACAURDIR"

cd /tmp/$TMPCOWERDIR
echo 'downloading cower'
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz | tar xz

cd /tmp/$TMPCOWERDIR/cower
echo 'makepkg cower'
makepkg --syncdeps --install --noconfirm

cd /tmp/$TMPPACAURDIR
echo 'downloading pacaur'
curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz | tar xz

cd /tmp/$TMPPACAURDIR/pacaur
echo 'makepkg pacaur'
makepkg --syncdeps --install --noconfirm
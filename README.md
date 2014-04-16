# dotfiles
 
Misc configuration files from my $HOME directory ;) ...

## Introduction

This is my repository containing some configuration files that I use on my *nix systems. Since this is to be used by myself, I sometimes hardcode strings (like my name/e-mail on my .gitconfig file), so this repo probably shouldn't be used by you without modifications.
 
Why all files on this repo are hidden? This is because this repo is supposed to be clonned on $HOME directory directly, instead to clone to some folder and using symlinks/shell voodoo to put the files on the correct place. This has some advantages (it's easier to manage files, especially if you use Zsh+Git integration like me), but this also means it's more difficult to other people to use this repo without forking it. And well, this is a dotfile repo, so it makes sense to README.md to be a dotfile too.

## Dependencies

This repository includes configuration files for the following programs (so you need them installed to use this repo). You can, of course, install only the things you want/need, but you will need to copy/link the files/folders in () to make it work:

  * .mpv (.mpv)
  * Sublime Text 3 (.config/sublime-text-3)
  * vim (.vim/.vimrc)
  * zsh (.zshrc/.oh-my-zsh/.zsh-syntax-highlighting)

Of course you need Git too ;) . If you do want to use my .gitconfig, don't
forget to change the e-mail and name, unless you want to commit things with my
name.
 
## Instalation

To install, simple clone this repository on your $HOME directory. After that, you need to do a:

```
  $ source ~/.zshrc
  $ updateplugins
```

on your $HOME directory since ```updateplugins``` is an alias to ```git submodule update --init --remote --recursive``` to install everything else. This make the update process of plugins less painful, since I only need to execute ```updateplugins``` to update every plugin I use to the lastest and greatest.

As a alternative, you can clone this repo anywhere you want and create symlinks or copy anything you think you want to use. This is probably easier, but you lose the ability to auto-track your modifications with Git. This is why I recommend you to fork this repo and make your changes on your own repository.

After instalation you need to run 

```
  :PluginInstall
```

on Vim command mode to install all plugins. There is no need to do something similar to Oh-My-Zsh or Package Control since they're self contained.

To finish, you probably don't want a README.md and LICENSE file on your home directory. You can delete them and use the following command to make Git ignore this change:

```
  $ git update-index --assume-unchanged README.md LICENSE
```

If you do need to edit either file, you can simple type:

```
  $ git checkout README.md LICENSE
  $ git update-index --no-assume-unchanged README.md LICENSE
```

And everything will work as before.

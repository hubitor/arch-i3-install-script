#!/usr/bin/env sh

yes | sudo pacman -S vim i3-wm xfce4-terminal xorg-xinit lxappearance ttf-dejavu faience-icon-theme feh zsh

git clone https://aur.archlinux.org/package-query.git
cd package-query
yes | makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
yes | makepkg -si
cd ..

rm -rf package-query yaourt

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo usermod -s /usr/bin/zsh $USER

yaourt -S --noconfirm dmenu2

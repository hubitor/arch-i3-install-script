#!/usr/bin/env sh

# Installing base packages
yes | sudo pacman -S vim xfce4-terminal xorg-xinit ttf-dejavu ttf-droid faience-icon-theme feh zsh

# Installing i3wm
cd i3-smart-borders
makepkg -si

# Installing yaourt
git clone https://aur.archlinux.org/package-query.git
cd package-query
yes | makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
yes | makepkg -si
cd ..
rm -rf package-query yaourt

# Installing oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Modifying config
sed -i -e s/robbyrussell/nanotech/g ~/.zshrc
echo "
  alias pac="sudo pacman"
  alias ya="yaourt --noconfirm"
" >> ~/.zshrc

# Setting shell to zsh
sudo usermod -s /usr/bin/zsh $USER

# Installing yaourt packages
yaourt -S --noconfirm dmenu2 j4-dmenu-desktop

git clone git://github.com/i3/i3
cd i3
curl https://raw.githubusercontent.com/ashinkarov/i3-extras/master/0x2493-patches/smart-border.patch | patch src/con.c
make
cd ..
rm -r i3

# Copying config files
cp -R configs/.* ~
sudo cp -R share/* /usr/share
sudo chmod -R 777 /usr/share/wallpapers

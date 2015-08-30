#!/usr/bin/env sh

# Installing base packages
yes | sudo pacman -S vim xfce4-terminal xorg-xinit ttf-dejavu ttf-droid faience-icon-theme feh zsh > /dev/null 2> /dev/null

# Installing i3wm
cd i3-smart-borders
yes | makepkg -si > /dev/null 2> /dev/null
cd ..

# Installing yaourt
git clone https://aur.archlinux.org/package-query.git  > /dev/null 2> /dev/null
cd package-query
yes | makepkg -si  > /dev/null 2> /dev/null
cd ..
git clone https://aur.archlinux.org/yaourt.git  > /dev/null 2> /dev/null
cd yaourt
yes | makepkg -si  > /dev/null 2> /dev/null
cd ..
rm -rf package-query yaourt

# Installing oh-my-zsh
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh  > /dev/null 2> /dev/null

# Modifying config
sed -i -e s/robbyrussell/nanotech/g ~/.zshrc
echo "
  alias pac="sudo pacman"
  alias ya="yaourt --noconfirm"
" >> ~/.zshrc

# Setting shell to zsh
sudo usermod -s /usr/bin/zsh $USER

# Installing yaourt packages
yaourt -S --noconfirm dmenu2 j4-dmenu-desktop  > /dev/null 2> /dev/null

git clone git://github.com/i3/i3  > /dev/null 2> /dev/null
cd i3
curl https://raw.githubusercontent.com/ashinkarov/i3-extras/master/0x2493-patches/smart-border.patch | patch src/con.c  > /dev/null 2> /dev/null
make  > /dev/null 2> /dev/null
cd ..
rm -r i3

# Copying config files
cp -R configs/{.config,.gtkrc-2.0,.i3,.xinitrc} ~
sudo cp -R share/{themes,wallpapers} /usr/share
sudo chmod -R 777 /usr/share/wallpapers

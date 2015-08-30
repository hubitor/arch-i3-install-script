#!/usr/bin/env sh

# Installing base packages
yes | sudo pacman -S vim i3-wm xfce4-terminal xorg-xinit ttf-dejavu faience-icon-theme feh zsh

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

# Copying config files
cp -R configs/.* ~
sudo cp -R share/* /usr/share

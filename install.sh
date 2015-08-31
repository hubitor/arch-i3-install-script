#!/usr/bin/env sh

set -e

sudo echo "Ok!"

# Installing base packages
echo "Installing base packages"
(yes | sudo pacman -Rs vim-minimal || true) > /dev/null 2> /dev/null
yes "" | sudo pacman -S xorg-server vim xfce4-terminal xorg-xinit ttf-dejavu ttf-droid faience-icon-theme feh zsh > /dev/null 2> /dev/null

# Installing i3wm
echo "Installing i3wm from git with smart borders patch"
cd i3-smart-borders
yes | makepkg -si > /dev/null 2> /dev/null
cd ..

# Installing yaourt
echo "Installing yaourt"
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
echo "Installing oh-my-zsh"
git clone https://github.com/robbyrussell/oh-my-zsh.git > /dev/null 2> /dev/null
(cat oh-my-zsh/tools/install.sh | sh || true) > /dev/null 2> /dev/null

# Modifying config
echo "Modifying zsh config"
sed -i -e s/robbyrussell/simpletech/g ~/.zshrc
echo "
  alias pac='sudo pacman'
  alias ya='yaourt --noconfirm'
" >> ~/.zshrc

# Setting shell to zsh
echo "Updating user shell"
sudo usermod -s /usr/bin/zsh $USER

# Installing yaourt packages
echo "Installing yaourt packages"
yaourt -S --noconfirm dmenu2 j4-dmenu-desktop sublime-text-dev i3lock-blur i3lock-wrapper > /dev/null 2> /dev/null

# Copying config files
echo "Copying configs"
cp -R configs/{.config,.gtkrc-2.0,.i3,.xinitrc} ~
cp configs/simpletech.zsh-theme ~/.oh-my-zsh/themes
sudo cp -R share/{themes,wallpapers} /usr/share
sudo cp -R etc/pacman.conf /etc
sudo chmod -R 777 /usr/share/wallpapers

echo "Updating pacman database"
sudo pacman -Sy

echo "Enabling autologin and X11 server start"
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I 38400 linux
" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile

echo "Done!"
echo "You may want to unlogin (to get zsh works), x server starts automaticly"

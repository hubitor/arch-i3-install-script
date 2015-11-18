#!/usr/bin/env sh

set -e

sudo echo "Ok!"

# Installing base packages
echo "Installing base packages"
(yes | sudo pacman -Rs vim-minimal || true) > /dev/null 2> /dev/null
yes "" | sudo pacman -S xdotool pkgfile thefuck xclip xorg-server vim xfce4-terminal xorg-xinit ttf-dejavu ttf-droid faience-icon-theme feh zsh dunst ghc ipython pulseaudio thunar screenfetch > /dev/null 2> /dev/null

# Installing yaourt
echo "Installing yaourt"
git clone --depth=1 https://aur.archlinux.org/package-query.git > /dev/null 2> /dev/null
cd package-query
yes | makepkg -si > /dev/null 2> /dev/null
cd ..
git clone --depth=1 https://aur.archlinux.org/yaourt.git > /dev/null 2> /dev/null
cd yaourt
yes | makepkg -si > /dev/null 2> /dev/null
cd ..
rm -rf package-query yaourt

# Installing oh-my-zsh
echo "Installing oh-my-zsh"
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git > /dev/null 2> /dev/null
(cat oh-my-zsh/tools/install.sh | sh || true) > /dev/null 2> /dev/null

# Modifying config
echo "Modifying zsh config"
sed -i -e s/robbyrussell/simpletech/g ~/.zshrc
echo "
eval \"\$(thefuck --alias fk)\"
eval \"\$(thefuck --alias fuck)\"
eval \"\$(thefuck --alias FUCK)\"

alias pac='sudo pacman --noconfirm --needed'
alias ya='yaourt --noconfirm'
alias clip='xclip -selection clipboard'

export WINEDEBUG=-all
export THEFUCK_RULES='sudo:pacman:cd_correction:cd_mkdir:cd_parent:git_not_command:mkdir_p:git_push_force'
" >> ~/.zshrc

# Setting shell to zsh
echo "Updating user shell"
sudo usermod -s /usr/bin/zsh $USER

# Installing yaourt packages
echo "Installing yaourt packages"
yaourt -S --noconfirm dmenu2 j4-dmenu-desktop sublime-text-dev i3lock-blur i3lock-wrapper intellij-idea-ultimate-edition pycharm-professional clion webstorm phpstorm 0xdbe-eap rubymine i3-git > /dev/null 2> /dev/null

# Copying config files
echo "Copying configs"
cp -R configs/{.config,.gtkrc-2.0,.i3,.xinitrc} ~
cp configs/simpletech.zsh-theme ~/.oh-my-zsh/themes
sudo cp -R share/{themes,wallpapers} /usr/share
sudo cp -R etc/pacman.conf /etc
sudo chmod -R 777 /usr/share/wallpapers

echo "Updating pacman database"
yes | sudo pacman -Sy > /dev/null 2> /dev/null

read -p "Are you want to enable autologin? <Y/n> " prompt
if [[ $prompt == "n" || $prompt == "no"  || $prompt == "N"  || $prompt == "No" ]]
then
  true
else
  echo "Enabling autologin and X11 server start"
  sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
  echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I 38400 linux
" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null
  echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile
fi

read -p "Are you use virtualbox? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "yes" || $prompt == "Y"  || $prompt == "Yes" ]]
then
  yes | sudo pacman -S virtualbox-guest-utils xf86-video-vesa > /dev/null 2> /dev/null

  echo "vboxguest
vboxsf
vboxvideo
" | sudo tee /etc/modules-load.d/vbox.conf > /dev/null
  
  sed -i '1iexec_always --no-startup-id "VBoxClient-all; sleep 0.5; feh --bg-scale /usr/share/wallpapers/nature-1.jpg"' ~/.i3/config
else
  true
fi

echo "Updating pkgfile database"
sudo pkgfile --update > /dev/null 2> /dev/null

echo "Done!"
echo "You may want to unlogin (to get zsh works), x server starts automaticly"

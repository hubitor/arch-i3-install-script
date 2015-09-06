#!/usr/bin/env sh

set -e

echo "Configuring root and creating user"

echo "Enter root password:"
passwd

read -p "Enter new user name: " NEWUSER
useradd -s /bin/bash -m -G wheel,audio,video $NEWUSER

echo "Enter $NEWUSER password:"
passwd $NEWUSER

echo "Copying files for $NEWUSER"
mkdir -p /home/$NEWUSER/arch-i3-install-script
cp -R configs etc i3-smart-borders 30-user.sh share /home/$NEWUSER/arch-i3-install-script
echo "arch-i3-install-script/30-user.sh" > /home/$NEWUSER/.bash_profile

echo "Done! Relogin to $NEWUSER to continue"


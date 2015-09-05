#!/usr/bin/env sh

set -e

echo "Starting raw installation for VM"

echo "Make partitions on disk"
parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary ext4 0% 100%
parted /dev/sda set 1 boot on

echo "Making filesystem"
mkfs.ext4 /dev/sda1 

echo "Mounting"
mount /dev/sda1 /mnt

echo "Setting up base packages"
yes "" | pacstrap -i /mnt base base-devel

echo "Generating fstab"
genfstab -U /mnt > /mnt/etc/fstab

echo "Chrooting into new system"
arch-chroot /mnt /bin/bash -x <<'EOF'
su -

echo "Setting up locales"
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

echo "Setting up time"
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo "Enabling network"
systemctl enable dhcpcd

echo "Setting up bootloader"
yes "" | pacman -S git grub
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit
EOF

umount -R /mnt

echo "Done, please reboot to continue installation"


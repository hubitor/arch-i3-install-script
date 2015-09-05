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
echo "@TODO"


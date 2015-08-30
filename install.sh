#!/usr/bin/env sh

read -p "Part your devices, make filesystems and mount to /mnt: "

yes "" | pacstrap -i /mnt base base-devel
genfstab -U /mnt > /mnt/etc/fstab

chmod +x ./install-chroot.sh
cp install-chroot.sh /mnt
cp locale.gen /mnt

arch-chroot /mnt /bin/bash -x <<'EOF'
su -
./install-chroot.sh
EOF

rm /mnt/install-chroot.sh
rm /mnt/locale.gen

umount -R /mnt
#reboot

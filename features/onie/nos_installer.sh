#!/bin/sh

set -exufo pipefail

ROOT_PART_LABEL="ROOT"

[ "$(onie-sysinfo -c)" = "x86_64" ]
[ "$(onie-sysinfo -t)" = "gpt" ]
[ "$(onie-sysinfo -l)" = "bios" ]

blk_dev=$(blkid | grep -F 'LABEL="ONIE-BOOT"' | head -n 1 | awk '{ print $1 }' |  sed 's/[1-9][0-9]*:.*$//' | sed 's/\([0-9]\)\(p\)/\1/')
[ -b "$blk_dev" ]

last_part_num="$(sgdisk -p $blk_dev | tail -n 1 | awk '{ print $1 }')"
part_num="$(( $last_part_num + 1 ))"

sgdisk --largest-new="$part_num" --change-name="$part_num:$ROOT_PART_LABEL" "$blk_dev"

partprobe

blk_suffix=""
(echo "$blk_dev" | grep -q mmcblk || echo "$blk_dev" | grep -q nvme) && blk_suffix="p"

part_dev="$blk_dev$blk_suffix$part_num"

mnt="$(mktemp -d)"
mkfs.ext4 -F -L "$ROOT_PART_LABEL" "$part_dev"
mount -t ext4 -o defaults,rw "$part_dev" "$mnt"

sed '1,/^# --- EXIT MARKER ---$/d' "$0" | base64 -d | xz -d | tar -x -C "$mnt"

echo "LABEL=ROOT / ext4 rw,errors=remount-ro,discard" > "$mnt/etc/fstab"

grub-install --boot-directory="$mnt" --recheck "$blk_dev"

. /mnt/onie-boot/onie/grub/grub-variables

kernel="$(cd "$mnt/boot/" && find . -name 'vmlinuz-*-amd64' | sed 's#^\./##' | head -n 1)"
initramfs="$(cd "$mnt/boot/" && find . -name 'initrd.img-*-amd64' | sed 's#^\./##' | head -n 1)"
[ -b "$kernel" ] && [ -b "$initramfs" ]

cat <<EOF > "$mnt/grub/grub.cfg"
$GRUB_SERIAL_COMMAND
terminal_input $GRUB_TERMINAL_INPUT
terminal_output $GRUB_TERMINAL_OUTPUT

set timeout=5

menuentry 'Garden Linux %%VERSION%%' {
        search --no-floppy --label --set=root $ROOT_PART_LABEL
        linux   /boot/$kernel $GRUB_CMDLINE_LINUX \$ONIE_EXTRA_CMDLINE_LINUX root=LABEL=ROOT rw
        initrd  /boot/$initramfs
}
EOF

/mnt/onie-boot/onie/grub.d/50_onie_grub >> "$mnt/grub/grub.cfg"

umount "$mnt"

onie-nos-mode -s

exit 0
# --- EXIT MARKER ---

#!/bin/bash

bootloader() {
    dlg BOOTLDR menu "BIOS Bootloader" "\nSelect which bootloader to use." \
            "rEFInd"         "rEFInd is a UEFI boot manager capable of launching EFISTUB kernels. It is designed to be platform-neutral and to simplify booting multiple OSes" \
            "systemd-boot"   "Default boot loader for systemd. Only supports EFI" \
            "grub"      "The Grand Unified Bootloader, standard among many Linux distributions" \
            "None"           "I already have a bootloader installed"

            # "syslinux - NO"  "A collection of boot loaders for booting drives, CDs, or over the network. Mainly used for non-EFI systems" \
    [ -n "$BOOTLDR" ] && BL=$BL_OK
}

bootloader_install() {
    # [ -z "$BOOTLDR" ] && return 0;
    # [ "$BOOTLDR" = "None" ] && return 0;

    case "$BOOTLDR" in
        "rEFInd")
            pacman -S --noconfirm --needed refind-efi
            refind-install || return 4;

            disk=$(findmnt / -o SOURCE --noheadings)
            [ -z "$disk" ] && return 3;
            PARTUUID=$(blkid -o value -s PARTUUID "$disk")
            [ -z "$PARTUUID" ] && echo no partuuid

            ID="PARTUUID=$PARTUUID"

            sed "s/\$IDENTIFIER/$ID/g" ./helper_files/refind_linux.conf > /boot/refind_linux.conf

            [ -f /etc/pacman.d/hooks/ ] || mkdir -p /etc/pacman.d/hooks/
            cp ./helper_files/refind.hook /etc/pacman.d/hooks/refind.hook || return 5
            ;;
        "systemd-boot")
            bootctl --path=/boot install || return 4;

            disk=$(findmnt / -o SOURCE --noheadings)
            [ -z "$disk" ] && return 3;
            PARTUUID=$(blkid -o value -s PARTUUID "$disk")
            [ -z "$PARTUUID" ] && echo no partuuid

            ID="PARTUUID=$PARTUUID"

            mkdir -p /boot/loader/entries/
            sed "s/\$IDENTIFIER/$ID/g" ./helper_files/arch.conf > /boot/loader/entries/arch.conf
            cp ./helper_files/loader.conf /boot/loader/loader.conf
            bootctl --path=/boot update || return 4;

            [ -f /etc/pacman.d/hooks/ ] || mkdir -p /etc/pacman.d/hooks/
            cp ./helper_files/100-systemd-boot.hook /etc/pacman.d/hooks/100-systemd-boot.hook
            ;;
        "grub")
            pacman -S --noconfirm --needed efibootmgr grub os-prober
            disk=$(findmnt / -o SOURCE --noheadings)
            [ -z "$disk" ] && return 3;

            if grub-install --efi-directory=/boot "$disk"; then
                grub-mkconfig -o /boot/grub/grub.cfg
            else
                return 4;
            fi

            # TODO add grub hook
            # [ -f /etc/pacman.d/hooks/ ] || mkdir -p /etc/pacman.d/hooks/
            ;;
        "None"|*)
            return 0;
            ;;
    esac
}


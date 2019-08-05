#!/bin/bash

pacman_conf_update() {
    cp ./helper_files/pacman.conf /etc/pacman.conf
    pacman -Syy archlinuxcn-keyring
}
# dlg USER_PKGS check " Packages " "$_packages" \
#         abiword "A Fully-featured word processor" "$(ofn abiword "${USER_PKGS[*]}")" \
#         alacritty "A cross-platform, GPU-accelerated terminal emulator" "$(ofn alacritty "${USER_PKGS[*]}")" \

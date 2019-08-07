#!/bin/bash

[[ $LINES ]] || LINES=$(tput lines)
[[ $COLUMNS ]] || COLUMNS=$(tput cols)
SHL=$((LINES - 20))
ANS=./ANSWER

source ./scripts/dialog.sh

source ./scripts/bootloader.sh

source ./scripts/user.sh

source ./scripts/system_files.sh
source ./scripts/mirrorlist.sh
source ./scripts/pacman_conf.sh

source ./scripts/default_packages.sh

source ./scripts/optional_packages.sh


BL=""
BL_OK="        - OK"
# BL=$BL_OK

USER=""
USER_OK="              - OK"
# USER=$USER_OK

SF=""
SF_OK="      - OK"
# SF=$SF_OK

DPKG=""
DPKG_OK="  - OK"
# DPKG=$DPKG

OPKG=""
OPKG_OK=" - OK"
# OPKG=$OPKG

# dlg USER_PKGS check " Packages " "$_packages" \
#         abiword "A Fully-featured word processor" "$(ofn abiword "${USER_PKGS[*]}")" \
#         alacritty "A cross-platform, GPU-accelerated terminal emulator" "$(ofn alacritty "${USER_PKGS[*]}")" \
#         atom "An open-source text editor developed by GitHub" "$(ofn atom "${USER_PKGS[*]}")" \
#         audacious "A free and advanced audio player based on GTK+" "$(ofn audacious "${USER_PKGS[*]}")" \
#         audacity "A program that lets you manipulate digital audio waveforms" "$(ofn audacity "${USER_PKGS[*]}")" \
#         cairo-dock "Light eye-candy fully themable animated dock" "$(ofn cairo-dock "${USER_PKGS[*]}")"

about() {
    msg "About TARBS" "\n This script is basically a copy of Luke Smith's LARBS (Luke's Auto-Rice Bootstrapping Scripts). \
It sets you up with a fresh i3-gaps install, just like LARBS, but with my configurations and my own personal preferences. \
It also installs a bootloader in case you dont have one already. The main difference Between TARBS and LARBS is that this \
script lets you choose whether you want to install non-critical programs (with my configurations) and some other system configuration files. You can read more about LARBS on https://larbs.xyz\n\n \
The code used in this script is mostly written by the people maintaining the ArchLabs distribution. That distribution is very nice and has an \
awesome installer, which I based this one on. Seriously, most of the code here is just copy pasted from their installer, check them out at https://archlabslinux.com."
}

main() {
    while true; do
        dlg OPTION menu "TARBS - Thomas' Auto-Rice Bootstrapping Scripts" "\nSelect what to do" \
                "Bootloader$BL"           "Select the system default bootloader" \
                "User$USER"               "Set up user and password" \
                "System Files$SF"         "Add/modify system files" \
                "Optional Packages$OPKG"  "Modify the optional packages to be installed" \
                "Default Packages$DPKG"   "Modify the default packages to be installed (may break something)" \
                "Install"                 "Install" \
                "About"                   "About TARBS" \
                "Exit"                    "Exit TARBS (NO CHANGES WILL BE SAVED)" || return 1

        # TODO: system files

        # Doesn't work with variables with spaces in it
        # case ${OPTION// *- OK/} in
        case $(echo $OPTION | sed 's/ *- OK//g') in
            "Bootloader")
                bootloader
                ;;
            "User")
                user
                ;;
            "System Files")
                system_files
                echo a >> sf.txt
                ;;
            "Install")
                # pacman_conf_update
                # mirrorlist_update

                # pacman -Syu --noconfirm

                # bootloader_install
                # user_add
                # default_packages_install
                # optional_packages_install

                ;;
            "About")
                about
                ;;
            "Exit")
                return 0;
                ;;
        esac
    done
}

main
clear

echo "$OPTION"
echo "${OPTION// *- OK/}"

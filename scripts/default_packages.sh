#!/bin/bash


default_packages_install() {
    pacman -S --needed --noconfirm $(tr "\n" " " helper_files/default_packages.txt)
}

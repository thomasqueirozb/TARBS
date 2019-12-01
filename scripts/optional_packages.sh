#!/bin/bash


optional_packages_install() {
    pacman -S --needed --noconfirm $(tr "\n" " " < helper_files/optional_packages.txt)
}


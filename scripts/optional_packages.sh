#!/bin/bash


optional_packages_install() {
    pacman -S --needed --noconfirm < helper_files/optional_packages.txt
}


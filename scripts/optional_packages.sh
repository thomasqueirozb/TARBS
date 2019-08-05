#!/bin/bash


optional_packages_install() {
    pacman -S --needed --noconfirm $(cat helper_files/optional_packages.txt |  tr "\n" " ")
}


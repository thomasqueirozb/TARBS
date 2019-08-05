#!/bin/bash


default_packages_install() {
    pacman -S --needed --noconfirm $(cat helper_files/default_packages.txt |  tr "\n" " ")
}

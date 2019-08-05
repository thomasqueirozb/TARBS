#!/bin/bash


default_packages_install() {
    pacman -S --needed --noconfirm < helper_files/default_packages.txt
}

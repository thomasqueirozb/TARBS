#!/bin/bash


optional_packages_install() {
    pacman -S --needed --noconfirm < optional_packages.txt
}


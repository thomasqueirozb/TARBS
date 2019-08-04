#!/bin/bash


default_packages_install() {
    pacman -S --needed --noconfirm < default_packages.txt
}

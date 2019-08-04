#!/bin/bash

mirrorlist_update() {
    # countries=$(awk '!/^(##( (Arch|Filtered|Generated)|$)|$|Server)/ {print $2}' /etc/pacman.d/mirrorlist | sort | uniq)
    country="Brazil"

    # TODO: Fix this so the same repos dont appear twice on the mirrorlist
    # Not working. For some reason the second grep adds a -- at line 5. No idea why this happens (at all).
    # echo "$(grep -A 1 "^## $country$" /etc/pacman.d/mirrorlist; grep -P -A 1 "^## (?!$country$)" /etc/pacman.d/mirrorlist)" > ./mirrorlist

    # Do not know if using /tmp/mirrorlist is needed but I think it isn't a good idea to change the file as I'm reading to it.
    # If this sin't aproblem it is better to output directly to /etc/pacman.d/mirrorlist
    echo "$(grep -A 1 "^## $country$" /etc/pacman.d/mirrorlist; cat /etc/pacman.d/mirrorlist)" > /tmp/mirrorlist
    cp /tmp/mirrorlist /etc/pacman.d/mirrorlist
    rm /tmp/mirrorlist
}

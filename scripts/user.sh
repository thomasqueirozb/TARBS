#!/bin/bash

user() {
    NEWUSER=''
    local u='' p='' p2='' rp='' rp2=''

    until [[ $NEWUSER ]]; do
        i=0
        tput cnorm
        dialog --insecure --backtitle "Installer" --separator $'\n' --title " User " --mixedform "" 0 0 0 \
            "Username:"  1 1 "$u" 1 11 "$COLUMNS" 0 0 \
            "Password:"  2 1 ''   2 11 "$COLUMNS" 0 1 \
            "Repeat:"    3 1 ''   3 11 "$COLUMNS" 0 1 \
            "--- Root password, if left empty the user password will be used ---" 6 1 '' 6 68 "$COLUMNS" 0 2 \
            "Password:"  8 1 ''   8 11 "$COLUMNS" 0 1 \
            "Repeat:"    9 1 ''   9 11 "$COLUMNS" 0 1 2>"$ANS" || return 1

        while read -r line; do
            case $i in
                0) u="$line" ;;
                1) p="$line" ;;
                2) p2="$line" ;;
                3) rp="$line" ;;
                4) rp2="$line" ;;
            esac
            (( i++ ))
        done < "$ANS"

        # root passwords empty, so use the user passwords
        [[ -z $rp && -z $rp2 ]] && { rp="$p"; rp2="$p2"; }

        # make sure a username was entered and that the passwords match
        if [[ ${#u} -eq 0 || $u =~ \ |\' || $u =~ [^a-z0-9] ]]; then
            msg "Invalid Username" "\nIncorrect user name.\n\nPlease try again.\n"; u=''
        elif [[ -z $p ]]; then
            msg "Empty Password" "\nThe user password cannot be left empty.\n\nPlease try again.\n"
        elif [[ "$p" != "$p2" ]]; then
            msg "Password Mismatch" "\nThe user passwords do not match.\n\nPlease try again.\n"
        elif [[ "$rp" != "$rp2" ]]; then
            msg "Password Mismatch" "\nThe root passwords do not match.\n\nPlease try again.\n"
        else
            NEWUSER="$u"
            USER_PASS="$p"
            ROOT_PASS="$rp"
            USER=$USER_OK
        fi
    done
}

user_add() {
    [ -z "$USER" ] && return 0;
    passwd root <<< "$(echo -e "$ROOT_PASS\\n$ROOT_PASS")"
    useradd -m -g users -G wheel "$NEWUSER"
    passwd $NEWUSER <<< "$(echo -e "$USER_PASS\\n$USER_PASS")"
}

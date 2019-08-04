#!/bin/bash

msg() {
    local title="$1" body="$2"
    tput civis
    if (( $# == 3 )); then
        dialog --backtitle "$DIST Installer - $SYS - v$VER" --sleep "$3" --title " $title " --infobox "$body\n" 0 0
    else
        dialog --backtitle "$DIST Installer - $SYS - v$VER" --title " $title " --msgbox "$body\n" 0 0
    fi
}
ofn() {
    [[ "$2" == *"$1"* ]] && printf "on" || printf "off"
}
dlg() {
    local var="$1" dialog_type="$2" title="$3" body="$4" n=0
    shift 4
    echo $#
    (( ($# / 2) > SHL )) && n=$SHL

    tput civis
    case "$dialog_type" in
        menu)
            dialog --backtitle "Installer" --title " $title " --menu "$body" 0 0 $n "$@" 2>"$ANS" || return 1
            ;;
        check)
            dialog --backtitle "$DIST Installer - $SYS - v$VER" --title " $title " --checklist "$body" 0 0 $n "$@" 2>"$ANS" || return 1
            ;;
        input)
            tput cnorm
            local def="$1"
            shift
            if [[ $1 == 'limit' ]]; then
                dialog --backtitle "$DIST Installer - $SYS - v$VER" --max-input 63 --title " $title " --inputbox "$body" 0 0 "$def" 2>"$ANS" || return 1
            else
                dialog --backtitle "$DIST Installer - $SYS - v$VER" --title " $title " --inputbox "$body" 0 0 "$def" 2>"$ANS" || return 1
            fi
            ;;
    esac
    [[ -s "$ANS" ]] && printf -v "$var" "%s" "$(< "$ANS")"
}



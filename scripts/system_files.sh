#!/bin/bash

system_files() {
    dlg SYS_FILES check "System Files" "PACK" \
            mirrorlist  "Filter mirrorlist by country" "" \
            archlinuxcn "Arch Linux China repo. Contains pre-compiled aur packages" "" \
            maximbaz    "Trusted User (TU). Contains pre compiled brave browser with patches" ""


    SF=$SF_OK
}

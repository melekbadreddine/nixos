#!/usr/bin/env bash
# Wofi logout menu matching Noctalia session menu style

# Options matching Noctalia's session menu
options=" Lock
 Logout
 Reboot
 Shutdown
 Reboot to UEFI"

# Show wofi menu centered on the active monitor
cmd=$(echo -e "$options" | wofi \
    --dmenu \
    --width 220 \
    --height 190 \
    --location center \
    --hide-search \
    --style ~/.config/wofi/gruvbox.css \
    --conf ~/.config/wofi/config)

case "$cmd" in
    *Lock)
        loginctl lock-session
        ;;
    *Logout)
        mango exit || loginctl terminate-session ""
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
    *"Reboot to UEFI")
        systemctl reboot --firmware-setup
        ;;
esac

#!/bin/bash
# Reload script for mango + waybar

# Reload mango config
mango -c ~/.config/mango/config.conf -p && mmsg -d reload_config
sleep 0.5

# Re-apply current theme (handles waybar, mako, wallpaper, GTK, kitty)
~/.config/mango/bin/switch-theme.sh --apply

crystal-dock &

# Optional: Send notification
notify-send "Config Reloaded" "Mango and theme reloaded successfully"

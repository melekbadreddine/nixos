#!/bin/bash
# Mango autostart script

set +e

# Import environment for systemd
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE

# Start xdg-desktop-portal backends
# (Main portal can't auto-start via systemd because graphical-session.target is inactive)
/usr/libexec/xdg-desktop-portal-gtk >/dev/null 2>&1 &
/usr/libexec/xdg-desktop-portal-wlr >/dev/null 2>&1 &
sleep 1
/usr/libexec/xdg-desktop-portal >/dev/null 2>&1 &

# Set GTK dark mode preference (for modern GTK4/libadwaita apps)
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# # Disable DualSense Edge trackpad-as-mouse functionality
# # This prevents the controller's touchpad from controlling the cursor in games
# # Run in background and wait a moment for any XWayland to be ready
# (
#     sleep 3
#     # Check if user is in input group
#     if groups | grep -q '\binput\b'; then
#         ~/.config/mango/bin/disable-dualsense-touchpad.py >/dev/null 2>&1 &
#     else
#         echo "Note: Add user to 'input' group for DualSense touchpad disabling:"
#         echo "  sudo usermod -a -G input \$USER"
#         echo "Then log out and back in."
#     fi
# ) &

# Noctalia shell (your preferred launcher/panel)
# qs -c noctalia-shell &

# Apply current theme (handles waybar, mako, wallpaper, GTK, kitty, qt5ct/qt6ct)
# This replaces manual waybar + wallpaper startup
~/.config/mango/bin/switch-theme.sh --apply &

# Crystal Dock
crystal-dock &

# Audio idle inhibitor - prevents screen sleep when audio is playing
# Perfect for streaming to prevent screen lock/sleep
#~/.config/mango/bin/audio-idle-inhibit.sh &

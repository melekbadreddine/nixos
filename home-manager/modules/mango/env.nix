{...}: {
  home.file.".config/mango/env.conf".text = ''
    # Environment variables for non-mango items (waybar, noctalia, etc.)

    # GTK/QT theming - force dark mode
    env=QT_QPA_PLATFORMTHEME,qt6ct
    env=QT5_QPA_PLATFORMTHEME,qt5ct

    # Cursor and icon themes
    env=XCURSOR_THEME,Macintosh
    env=XCURSOR_SIZE,24

    # Include flatpak exports for icons and desktop files
    env=XDG_DATA_DIRS,$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$HOME/.local/share:/usr/local/share:/usr/share

    # Session type
    env=XDG_CURRENT_DESKTOP,mango
    env=XDG_SESSION_TYPE,wayland

    # Wayland Protocol Variables (Restoring from template)
    env=QT_QPA_PLATFORM,wayland
    env=QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env=GDK_BACKEND,wayland,x11
    env=MOZ_ENABLE_WAYLAND,1
    env=SDL_VIDEODRIVER,wayland
    env=CLUTTER_BACKEND,wayland

    # VirtualBox 3D Acceleration Note:
    # Uncomment the following line if 3D acceleration is disabled in VirtualBox
    # env=WLR_RENDERER,pixman
  '';
}

{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "mango-autostart" ''
      set +e

      # Import environment for systemd
      ${pkgs.systemd}/bin/systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE

      # Start xdg-desktop-portal backends
      ${pkgs.bash}/bin/sleep 1
      ${pkgs.libnotify}/bin/notify-send "Mango WM" "Desktop session starting..."

      # Set GTK dark mode preference
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

      # Apply current theme (Verbatim: switch-theme.sh --apply)
      switch-theme --apply &

      # Crystal Dock (Independent component)
      ${pkgs.crystal-dock}/bin/crystal-dock &
    '')
  ];
}

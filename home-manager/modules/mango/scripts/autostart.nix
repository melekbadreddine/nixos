{vars, ...}: {
  home.file.".config/mango/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Kill already running processes
      killall -q awww-daemon quickshell dunst hyprpolkitagent

      # Start Daemons
      awww-daemon &

      # Wait for daemon to be ready
      sleep 0.5

      # Set wallpaper
      awww img ${vars.stylixImage} &

      # Start Bar/Shell
      quickshell ~/.config/quickshell/shell.qml &

      dunst &
      hyprpolkitagent &

      # Clipboard history
      wl-paste --watch cliphist store &
    '';
  };
}

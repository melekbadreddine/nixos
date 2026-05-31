{...}: {
  home.file.".config/mangowc/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      awww-daemon &
      quickshell &
      dunst &
      hyprpolkitagent &
      wl-paste --watch cliphist store &
    '';
  };
}

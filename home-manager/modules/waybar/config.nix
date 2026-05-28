{pkgs, ...}: {
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 36;
      margin-top = 7;
      margin-left = 446;
      margin-right = 446;
      spacing = 6;

      modules-left = [
        "image"
        "dwl/tags"
        "dwl/window"
      ];

      modules-center = [
        "cpu"
        "temperature"
        "memory"
        "disk"
        "network"
      ];

      modules-right = [
        "tray"
        "custom/notifications"
        "battery"
        "pulseaudio"
        "clock"
        "custom/power"
      ];

      "image" = {
        exec = "mango-nixos-logo";
        size = 18;
        interval = "once";
        tooltip = false;
      };

      "dwl/tags" = {
        num-tags = 9;
        tag-labels = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
      };

      "dwl/window" = {
        format = "{title}";
        max-length = 50;
        rewrite = {
          "(.*) — Mozilla Firefox" = " $1";
          "(.*) - Chromium" = " $1";
          "(.*) - Visual Studio Code" = " $1";
          "(.*) - zed" = " $1";
          "(.*) - Discord" = " $1";
          "(.*) - Steam" = " $1";
        };
      };

      cpu = {
        format = " {usage}%";
        interval = 2;
        tooltip = true;
        tooltip-format = "CPU: {usage}%";
      };

      temperature = {
        format = " {temperatureC}°";
        interval = 2;
        tooltip = true;
        tooltip-format = "CPU Temp: {temperatureC}°C";
      };

      memory = {
        format = " {used:0.1f}G";
        interval = 2;
        tooltip = true;
        tooltip-format = "RAM: {used:0.1f}GB / {total:0.1f}GB ({percentage}%)";
      };

      disk = {
        format = " {used}";
        interval = 30;
        path = "/";
        tooltip = true;
        tooltip-format = "Disk: {used} / {total} ({percentage_used}%)";
      };

      network = {
        format-wifi = " {bandwidthDownBytes}   {bandwidthUpBytes}";
        format-ethernet = " {bandwidthDownBytes}   {bandwidthUpBytes}";
        format-disconnected = "󰤭 Offline";
        interval = 2;
        tooltip = true;
        tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\nDown: {bandwidthDownBits}\nUp: {bandwidthUpBits}";
        tooltip-format-ethernet = "Ethernet: {ifname}\nDown: {bandwidthDownBits}\nUp: {bandwidthUpBits}";
      };

      tray = {
        icon-size = 16;
        spacing = 8;
        show-passive-items = true;
      };

      "custom/notifications" = {
        format = "{}";
        exec = "mango-notifications";
        interval = 2;
        return-type = "json";
        on-click = "makoctl dismiss --all";
        on-click-right = "makoctl restore";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-icons = ["" "" "" "" ""];
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        tooltip = true;
        tooltip-format = "{timeTo} {capacity}%";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " Muted";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
        on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
        on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
        tooltip = true;
        tooltip-format = "{desc}";
      };

      clock = {
        format = "{:%I:%M %p %a, %b %d}";
        tooltip = true;
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='#d79921'><b>{}</b></span>";
            weekdays = "<span color='#d79921'><b>{}</b></span>";
            today = "<span color='#b8bb26'><b>{}</b></span>";
          };
        };
      };

      "custom/power" = {
        format = "";
        tooltip = "Session Menu";
        on-click = "wlogout";
      };
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "layout-switcher" ''
      set -euo pipefail
      declare -A LAYOUTS=(
          [T]="Tile"
          [S]="Scroller"
          [G]="Grid"
          [M]="Monocle"
          [K]="Deck"
          [CT]="Center Tile"
          [RT]="Right Tile"
          [VS]="Vertical Scroller"
          [VT]="Vertical Tile"
          [VG]="Vertical Grid"
          [VK]="Vertical Deck"
          [TG]="TGMix"
      )
      state=$(mmsg -g 2>/dev/null || echo "")
      if [[ -z "$state" ]]; then
          echo '{"text":"N/A","tooltip":"Mango WM not running"}'
          exit 0
      fi
      focused_mon=$(echo "$state" | grep "selmon 1" | awk '{print $1}')
      if [[ -z "$focused_mon" ]]; then
          echo '{"text":"N/A","tooltip":"No focused monitor"}'
          exit 0
      fi
      code=$(echo "$state" | grep "^''${focused_mon} layout " | awk '{print $NF}')
      if [[ -z "$code" ]] || [[ -z "''${LAYOUTS[$code]+x}" ]]; then
          echo "{\"text\":\"$code\",\"tooltip\":\"Unknown layout: $code\"}"
          exit 0
      fi
      name="''${LAYOUTS[$code]}"
      echo "{\"text\":\"$name\",\"tooltip\":\"Layout: $name ($code)\nClick to change\"}"
    '')
  ];
}

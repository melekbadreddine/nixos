{colors}: {
  compositor = "mango";
  theme = {
    mode = "dark";
    source = "custom";
    custom = {
      base = "#${colors.base00}";
      mantle = "#${colors.base01}";
      crust = "#${colors.base00}";
      surface0 = "#${colors.base02}";
      surface1 = "#${colors.base03}";
      surface2 = "#${colors.base04}";
      text = "#${colors.base05}";
      subtext0 = "#${colors.base04}";
      subtext1 = "#${colors.base05}";
      overlay0 = "#${colors.base03}";
      overlay1 = "#${colors.base04}";
      overlay2 = "#${colors.base05}";
      blue = "#${colors.base0D}";
      lavender = "#${colors.base0C}";
      sapphire = "#${colors.base0C}";
      sky = "#${colors.base0C}";
      teal = "#${colors.base0B}";
      green = "#${colors.base0B}";
      yellow = "#${colors.base0A}";
      peach = "#${colors.base09}";
      maroon = "#${colors.base08}";
      red = "#${colors.base08}";
      mauve = "#${colors.base0E}";
      pink = "#${colors.base0E}";
      flamingo = "#${colors.base0E}";
      rosewater = "#${colors.base06}";
    };
  };

  bar = {
    position = "top";
    height = 40;
    margin = {
      top = 8;
      left = 12;
      right = 12;
      bottom = 0;
    };
    border-radius = 14;
    opacity = 0.90;
    spacing = 6;
    modules-left = ["launcher" "workspaces"];
    modules-center = ["clock"];
    modules-right = ["network" "audio" "battery" "notifications"];
  };

  launcher = {
    enabled = true;
    icon = "󱗼";
    tooltip = false;
  };

  workspaces = {
    on-click = "activate";
    on-scroll-up = "next";
    on-scroll-down = "prev";
    format = "{id}";
    format-active = "{id}";
    active-only = false;
    persistent = [1 2 3 4 5];
  };

  clock = {
    format = "  %H:%M";
    format-alt = "  %a %d %b";
    tooltip = true;
    tooltip-format = "{:%A, %d %B %Y  •  %H:%M}";
    on-click = "format-alt";
    interval = 60;
  };

  network = {
    interval = 5;
    format-wifi = "  {essid}";
    format-ethernet = "󰈀  {ifname}";
    format-disconnected = "󰤭  Offline";
    format-linked = "󰤫  {ifname}";
    tooltip = true;
    tooltip-format-wifi = "{essid}  {signalStrength}%\n{ipaddr}";
    tooltip-format-ethernet = "{ifname}\n{ipaddr}";
    on-click = "nm-connection-editor";
  };

  audio = {
    format = "{icon}  {volume}%";
    format-muted = "󰖁  Muted";
    format-icons = {
      default = ["󰕿" "󰖀" "󰕾"];
      headphone = "󰋋";
      speaker = "󰓃";
    };
    scroll-step = 2;
    on-click = "pavucontrol";
    on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    tooltip = true;
    tooltip-format = "{desc}";
  };

  battery = {
    interval = 30;
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{icon}  {capacity}%";
    format-charging = "󰂄  {capacity}%";
    format-plugged = "󰚥  {capacity}%";
    format-full = "󰁹  Full";
    format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
    tooltip = true;
    tooltip-format = "{timeTo}";
  };

  notifications = {
    enabled = true;
    position = "top-right";
    on-click = "swaync-client -t";
    format = "󰂚";
    format-dnd = "󰂛";
    tooltip = false;
  };

  wallpaper = {
    enabled = false;
  };
}

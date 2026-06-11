{colors}: {
  compositor = "mango";

  theme = {
    mode = "dark";
    source = "custom";
    # Map base16 → Noctalia palette
    custom = {
      base = "#${colors.base00}"; # darkest bg
      mantle = "#${colors.base01}"; # slightly lighter bg
      crust = "#${colors.base00}"; # darkest bg alias
      surface0 = "#${colors.base02}";
      surface1 = "#${colors.base03}";
      surface2 = "#${colors.base04}";
      text = "#${colors.base05}"; # primary text
      subtext0 = "#${colors.base04}";
      subtext1 = "#${colors.base05}";
      overlay0 = "#${colors.base03}";
      overlay1 = "#${colors.base04}";
      overlay2 = "#${colors.base05}";
      blue = "#${colors.base0D}"; # accent / blue
      lavender = "#${colors.base0C}"; # cyan
      sapphire = "#${colors.base0C}";
      sky = "#${colors.base0C}";
      teal = "#${colors.base0B}"; # green
      green = "#${colors.base0B}";
      yellow = "#${colors.base0A}";
      peach = "#${colors.base09}";
      maroon = "#${colors.base08}";
      red = "#${colors.base08}"; # urgent / red
      mauve = "#${colors.base0E}"; # purple
      pink = "#${colors.base0E}";
      flamingo = "#${colors.base0E}";
      rosewater = "#${colors.base06}";
    };
  };

  bar = {
    position = "top";
    height = 36;
    margin = {
      top = 6;
      left = 8;
      right = 8;
    };
    border-radius = 10;
    opacity = 0.92;
    modules-left = ["workspaces"];
    modules-center = ["clock"];
    modules-right = ["network" "audio" "battery"];
  };

  workspaces = {
    on-click = "activate";
    format = "{id}";
  };

  clock = {
    format = "%d/%m/%Y  %H:%M";
    tooltip = false;
  };

  network = {
    format-disconnected = "󰪎  Offline";
    format-ethernet = "  {ifname}";
    format-wifi = "{icon}  {percent}%";
    tooltip = true;
  };

  audio = {
    format = "{icon}  {volume}%";
    format-muted = "󰖁  {volume}%";
    on-click = "pavucontrol";
  };

  wallpaper = {
    enabled = false; # We use swaybg via mango autostart instead
  };

  notifications = {
    enabled = true;
    position = "top-right";
  };

  launcher = {
    enabled = true;
  };
}

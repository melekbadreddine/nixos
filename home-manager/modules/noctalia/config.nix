{colors}: {
  # ── Theme ────────────────────────────────────────────────────────────────
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

  # ── Bar ──────────────────────────────────────────────────────────────────
  bar.order = ["main"];

  "bar.main" = {
    position = "top";
    enabled = true;
    thickness = 38;
    background_opacity = 0.88;
    margin_edge = 8; # float the bar 8px from screen edge
    margin_ends = 10; # inset from left/right ends
    radius = 14;
    shadow = true;
    border = "outline";
    border_width = 1.0;
    widget_spacing = 6;
    font_weight = "regular";

    # Enable capsules globally — gives each widget its own pill background
    capsule = true;
    capsule_fill = "surface_variant";
    capsule_radius = 10.0;
    capsule_opacity = 0.85;

    start = ["launcher" "workspaces"];
    center = ["clock"];
    end = ["network" "volume" "battery" "notifications" "control-center"];
  };

  # ── Widgets ───────────────────────────────────────────────────────────────

  "widget.launcher" = {
    type = "launcher";
    icon = "󱗼";
  };

  "widget.workspaces" = {
    type = "workspaces";
    display = "id";
    minimal = false;
    hide_when_empty = false;
    labels_only_when_occupied = true;
    focused_color = "primary";
    occupied_color = "secondary";
    empty_color = "surface_variant";
    pill_scale = 0.9;
  };

  "widget.clock" = {
    type = "clock";
    format = " {:%H:%M}";
    tooltip_format = "{:%A, %d %B %Y}";
  };

  "widget.network" = {
    type = "network";
  };

  "widget.volume" = {
    type = "volume";
  };

  "widget.battery" = {
    type = "battery";
  };

  "widget.notifications" = {
    type = "notifications";
  };

  "widget.control-center" = {
    type = "control-center";
  };

  # ── Wallpaper ─────────────────────────────────────────────────────────────
  "wallpaper" = {
    enabled = false;
  };
}

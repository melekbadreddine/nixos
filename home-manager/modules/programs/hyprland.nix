{ pkgs, ... }: {
  # Install necessary packages
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono

    # Hyprland Utilities
    waybar       # Status bar
    dunst        # Notifications
    swww         # Wallpaper
    kitty        # Terminal
    rofi         # App launcher
    kdePackages.dolphin      # File manager
  ];

  # Basic Hyprland Configuration
  wayland.windowManager.hyprland = {
    enable = true;
    # Use the system-level Hyprland package to avoid conflicts
    package = null;
    portalPackage = null;
    
    settings = {
      "$mod" = "SUPER";

      monitor = "Virtual-1, 1920x1080@60, 0x0, 1";

      ecosystem = {
        no_update_news = true;
      };

      input = {
        kb_layout = "fr";
      };

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, R, exec, rofi -show drun"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ];

      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "LIBGL_ALWAYS_SOFTWARE,1"
        "WLR_BACKEND,pixman"
        "WLR_RENDERER,pixman"
      ];

      # Visuals
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      decoration = {
        rounding = 0;
        shadow = {
          enabled = false;
        };
        blur = {
          enabled = false;
        };
      };
    };
  };

  # Configure Fonts for Home Manager
  fonts.fontconfig.enable = true;
}


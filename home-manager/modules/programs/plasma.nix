{ host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) stylixImage;
in
{
  programs.plasma = {
    enable = true;

    # Panels configuration
    panels = [
      # Top "Island" Panel (Waybar-like)
      {
        location = "top";
        height = 32;
        floating = true;
        alignment = "center";
        lengthMode = "fill";
        
        widgets = [
          # Left: Menu and Workspaces
          {
            name = "org.kde.plasma.kickoff";
            config.General.icon = "nix-snowflake";
          }
          "org.kde.plasma.pager"
          
          # Spacer to center modules
          "org.kde.plasma.panelspacer"

          # Center: System Monitoring (matching Waybar modules-center)
          "org.kde.plasma.systemmonitor.cpu"
          "org.kde.plasma.systemmonitor.memory"
          
          # Spacer to push modules to the right
          "org.kde.plasma.panelspacer"

          # Right: Status Icons, Clock, and System Tray (matching Waybar modules-right)
          "org.kde.plasma.battery"
          "org.kde.plasma.volume"
          "org.kde.plasma.keyboardlayout"
          "org.kde.plasma.networkmanagement"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.lock_logout"
        ];
      }
    ];

    # Window Decorations and Theme
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breeze.desktop";
      windowDecoration = {
        library = "org.kde.klassy";
        theme = "Klassy";
      };
    };

    # Lock screen configuration
    kscreenlocker.appearance.wallpaper = stylixImage;

    # Simplified config to avoid crashes during initial rice
    configFile = {
      kwinrc = {
        "Plugins" = {
          "blurEnabled" = true;
          "translucencyEnabled" = true;
        };
      };
    };
  };
}

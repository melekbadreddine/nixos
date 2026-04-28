{ host, lib, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) stylixImage;
in
{
  programs.plasma = {
    enable = true;

    # Restore lookAndFeel to ensure a working base theme
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breeze.desktop";
      windowDecoration = {
        library = "org.kde.klassy";
        theme = "Klassy";
      };
    };

    # Set wallpaper for the desktop as well
    desktop.wallpaper = stylixImage;

    # Panels configuration
    panels = [
      # Top Panel (Simplified for stability)
      {
        location = "top";
        height = 32;
        floating = false; # Set to false temporarily for stability
        alignment = "center";
        lengthMode = "fill";
        
        widgets = [
          # Left
          {
            name = "org.kde.plasma.kickoff";
            config.General.icon = "nix-snowflake";
          }
          "org.kde.plasma.pager"
          
          "org.kde.plasma.panelspacer"

          # Center
          "org.kde.plasma.icontasks"
          
          "org.kde.plasma.panelspacer"

          # Right
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # Lock screen configuration
    kscreenlocker.appearance.wallpaper = stylixImage;

    # Ensure basic kwin effects
    configFile.kwinrc."Plugins" = {
      "blurEnabled" = true;
      "translucencyEnabled" = true;
    };
  };
}

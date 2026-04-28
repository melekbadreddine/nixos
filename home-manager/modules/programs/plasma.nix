{ ... }:

{
  programs.plasma = {
    enable = true;

    # Panels configuration
    panels = [
      # Top "Island" Panel
      {
        location = "top";
        height = 32;
        floating = true;
        alignment = "center";
        lengthMode = "fill"; # Change to fill to ensure it's visible, then refine
        
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config.General.icon = "nix-snowflake";
          }
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      # Bottom Mac-like Dock
      {
        location = "bottom";
        height = 56;
        floating = true;
        alignment = "center";
        lengthMode = "fit";
        
        widgets = [
          {
            name = "org.kde.plasma.icontasks";
            config.General.launchers = [
              "applications:org.kde.dolphin.desktop"
              "applications:kitty.desktop"
              "applications:firefox.desktop"
            ];
          }
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

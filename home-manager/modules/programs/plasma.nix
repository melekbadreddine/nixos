{ ... }:

{
  programs.plasma = {
    enable = true;

    # Panels configuration
    panels = [
      # Top "Island" Panel (Waybar-like)
      {
        location = "top";
        height = 30;
        floating = true;
        alignment = "center";
        lengthMode = "custom";
        minLength = 100;
        maxLength = 100;
        
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
        lengthMode = "fit"; # Shrinks to fit icons like a dock
        
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

    # Workspace and Window Manager settings
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breeze.desktop";
      cursor.theme = "Bibata-Modern-Ice";
    };

    # Custom configuration for transparency and rounded corners
    # Note: Full rounded corners on windows often requires a specific theme or KWin script,
    # but we can enable transparency effects here.
    configFile = {
      kwinrc = {
        "Desktops" = {
          "Number" = 4;
          "Rows" = 1;
        };
        "Plugins" = {
          "translucencyEnabled" = true;
          "blurEnabled" = true;
        };
      };
      # Setting window opacity (Active/Inactive)
      kwinrulesrc = {
        "1" = {
          "Description" = "Global Opacity";
          "opacityactive" = 95;
          "opacityinactive" = 85;
          "wmclass" = ".*";
          "wmclassmatch" = 3;
        };
      };
    };
  };
}

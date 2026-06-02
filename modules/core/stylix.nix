{
  pkgs,
  vars,
  lib,
  ...
}: let
  # Color Schemes available: "catppuccin-mocha" or "tokyo-night"
  currentTheme = "catppuccin-mocha";

  # Icon Themes available: "papirus" or "gruvbox"
  currentIcons = "papirus";

  # Theme Definitions Mapped via Base16
  themeSchemes = {
    catppuccin-mocha = pkgs.base16-schemes + "/share/themes/catppuccin-mocha.yaml";
    tokyo-night = pkgs.base16-schemes + "/share/themes/tokyo-night.yaml";
  };

  # Icon Map Definitions
  iconConfigs = {
    papirus = {
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus";
    };
    gruvbox = {
      package = pkgs.gruvbox-plus-icons;
      dark = "Gruvbox-Plus-Dark";
      light = "Gruvbox-Plus-Light";
    };
  };
in
  lib.mkIf vars.stylixEnable {
    stylix = {
      enable = true;
      image = vars.stylixImage;

      # Dynamically picks based on your choice at the top
      base16Scheme = themeSchemes.${currentTheme};
      polarity = "dark";

      autoEnable = true;

      targets = {
        console.enable = true;
        kmscon.enable = false;
        plymouth.enable = true;
        gtk.enable = false;
        qt.enable = false;
      };

      opacity = {
        desktop = 0.2;
      };

      # Dynamically picks your icon pack from the choice at the top
      icons =
        {
          enable = true;
        }
        // iconConfigs.${currentIcons};

      # Phinger Dark Cursor Setup
      cursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.departure-mono;
          name = "DepartureMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.departure-mono;
          name = "DepartureMono Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.departure-mono;
          name = "DepartureMono Nerd Font";
        };
      };
    };
  }

{
  pkgs,
  vars,
  lib,
  ...
}:
lib.mkIf vars.stylixEnable {
  stylix = {
    enable = true;
    image = vars.stylixImage;
    base16Scheme = pkgs.base16-schemes + "/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    # Enable automatic styling to ensure wallpaper and system-wide themes are applied.
    autoEnable = true;

    # Explicit layout configuration for UI toolkits
    targets = {
      console.enable = true;
      plymouth.enable = true;
      gtk.enable = false;
      qt.enable = false;
    };

    # Tweaked background element transparency
    opacity = {
      desktop = 0.2;
    };

    # Integrated custom Papirus icon theme styling
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus";
    };

    # Breeze Dark Cursor Setup
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

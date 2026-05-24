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
    # Manual overrides are handled in home-manager/modules/stylix.nix.
    autoEnable = true;

    targets = {
      console.enable = true;
      plymouth.enable = true;
    };

    cursor = {
      package = pkgs.apple-cursor;
      name = "Macintosh";
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

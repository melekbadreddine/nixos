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

    # Disable automatic styling to prevent it from overriding the SDDM theme.
    # Manual overrides are handled in home-manager/modules/stylix.nix.
    autoEnable = false;

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

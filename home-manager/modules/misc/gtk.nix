{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Catppuccin-Mocha-Standard-Blue-Dark";
      package = lib.mkForce (pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "standard";
        tweaks = ["rimless"];
        variant = "mocha";
      });
    };
    gtk4.theme = null;
    iconTheme = {
      name = lib.mkForce "Papirus-Dark";
      package = lib.mkForce pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = lib.mkForce "Catppuccin-Mocha-Blue-Cursors";
      package = lib.mkForce pkgs.catppuccin-cursors.mochaBlue;
    };
  };
}

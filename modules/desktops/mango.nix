{pkgs, ...}: {
  # Enable Mango WM (River-based Wayland compositor)
  # Mango is available in nixpkgs as pkgs.mangowc
  environment.systemPackages = [
    pkgs.mangowc
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config.common.default = "*";
  };

  services.gnome.gnome-keyring.enable = true;
}

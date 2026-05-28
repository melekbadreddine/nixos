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

  # Core Wayland Session Variables for SDDM to pass to Mango
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "mango";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}

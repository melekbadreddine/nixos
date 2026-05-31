{pkgs, ...}: {
  programs.mangowc.enable = true;

  environment.systemPackages = with pkgs; [
    quickshell
    rofi
    dunst
    awww
    hyprpolkitagent
    cliphist
    wl-clipboard
    grim
    slurp
    libnotify
    upower
  ];

  services.upower.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = ["wlr" "gtk"];
  };
}

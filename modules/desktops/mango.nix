{pkgs, ...}: {
  programs.mangowc = {
    enable = true;
  };

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
}

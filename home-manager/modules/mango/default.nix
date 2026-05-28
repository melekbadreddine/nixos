{pkgs, ...}: {
  imports = [
    ./config.nix
    ./env.nix
    ./monitor.nix
    ./tags.nix
    ./rules.nix
    ./scripts/autostart.nix
    ./scripts/theme-switch.nix
    ./scripts/wall-select.nix
    ./scripts/layout-picker.nix
    ./scripts/screenshot.nix
    ./scripts/notifications.nix
    ./scripts/waybar-gen.nix
  ];

  home.packages = with pkgs; [
    wofi
    mako
    grim
    slurp
    wl-clipboard
    imagemagick
    jq
    libnotify
    awww
    wlogout
    gruvbox-plus-icons
    python3
    python3Packages.pygobject3
    gtk3
    gtk4
  ];
}

{
  pkgs,
  inputs,
  ...
}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [
      (inputs.sddm-astronaut-theme.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        embeddedTheme = "hyprland_kath";
      })
      pkgs.kdePackages.qtmultimedia
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qttools
    ];
  };
}

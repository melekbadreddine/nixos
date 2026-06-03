{pkgs, ...}: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.theme = "sddm-astronaut-theme";

  environment.systemPackages = [
    pkgs.sddm-astronaut
  ];
}

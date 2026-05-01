{ pkgs, ... }:

{
  # Enable the Plasma 6 Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  # Enable the SDDM Display Manager.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Remove default Plasma apps we do not want.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
    konsole
    khelpcenter
    plasma-welcome
  ];
}

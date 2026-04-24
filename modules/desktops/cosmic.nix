{ config, pkgs, ... }:

{
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Configure keymap
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Optional: System76 scheduler for better performance
  services.system76-scheduler.enable = true;
}

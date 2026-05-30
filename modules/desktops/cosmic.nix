{
  pkgs,
  vars,
  lib,
  ...
}: {
  services.desktopManager.cosmic.enable = vars.cosmicEnable;
  services.displayManager.cosmic-greeter.enable = vars.cosmicGreeterEnable;

  # Remove bloat only if cosmic is enabled
  environment.cosmic.excludePackages = lib.mkIf vars.cosmicEnable (with pkgs; [
    cosmic-store
    firefox-unwrapped
  ]);
}

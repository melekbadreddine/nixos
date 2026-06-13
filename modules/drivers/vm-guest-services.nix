{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.vm.guest-services;
in {
  options.vm.guest-services = {
    enable = mkEnableOption "Enable Virtual Machine Guest Services";
  };
  config = mkIf cfg.enable {
    virtualisation.vmware.guest = {
      enable = true;
      headless = false;
    };
    services.xserver.videoDrivers = ["modesetting"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}

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
    # VirtualBox Guest Additions
    virtualisation.virtualbox.guest = {
      enable = true;
      dragAndDrop = true;
    };
    # VMSVGA uses the vmwgfx kernel DRM driver
    services.xserver.videoDrivers = ["vmware"];
    # Enable graphics stack + 3D via virgl/vmwgfx
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    environment.variables = {
      # Required for wlroots compositors in VMs
      WLR_NO_HARDWARE_CURSORS = "1";
      # Let Mesa use vmwgfx/virgl — do NOT force llvmpipe with 3D acceleration enabled
      LIBGL_ALWAYS_SOFTWARE = "0";
    };
  };
}

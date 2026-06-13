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
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    # Hardware acceleration for VMs
    hardware.graphics = {
      enable = true;
      # 3D acceleration in VMs often requires these for Virgil/SVGA
      enable32Bit = true;
    };

    # VirtualBox Guest Additions
    virtualisation.virtualbox.guest.dragAndDrop = true;

    # Better VM graphics performance
    services.xserver.videoDrivers = ["vmware" "modesetting"];

    environment.variables = {
      # Prefer stable software rendering for GPU-sensitive apps under VirtualBox 3D.
      GSK_RENDERER = "cairo";
      LIBGL_ALWAYS_SOFTWARE = "1";
      MESA_LOADER_DRIVER_OVERRIDE = "llvmpipe";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # spice-webdavd is disabled due to build failure with davsfs2 (unsupported neon version)
    # Enable if your system doesn't encounter this issue
    services.spice-webdavd.enable = false;
  };
}

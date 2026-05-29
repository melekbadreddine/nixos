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
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.dragAndDrop = true;

    # Better VM graphics performance
    services.xserver.videoDrivers = ["vmware" "modesetting"];

    environment.variables = {
      # Help GTK4/Adwaita apps run better in VMs with 3D acceleration
      GSK_RENDERER = "ngl";
      # Ghostty and other GPU-accelerated terminals sometimes need a hint
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # spice-webdavd is disabled due to build failure with davsfs2 (unsupported neon version)
    # Enable if your system doesn't encounter this issue
    services.spice-webdavd.enable = false;
  };
}

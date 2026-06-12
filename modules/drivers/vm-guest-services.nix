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
    # Hardware acceleration for VMs
    hardware.graphics = {
      enable = true;
      # 3D acceleration in VMs often requires these for Virgil/SVGA
      enable32Bit = true;
    };

    # VirtualBox Guest Additions
    virtualisation.virtualbox.guest = {
      enable = true;
      dragAndDrop = true;
    };

    # Better VM graphics performance
    services.xserver.videoDrivers = ["modesetting" "virtualbox"];

    environment.variables = {
      # MangoWC/Wayland under virtual machine: disable hardware cursors
      WLR_NO_HARDWARE_CURSORS = "1";
      # Let Mesa auto-select; 3D acceleration supports virgl so don't force llvmpipe
      LIBGL_ALWAYS_SOFTWARE = "0";
    };

    # spice-webdavd is disabled due to build failure with davsfs2
    # Enable if your system doesn't encounter this issue
    services.spice-webdavd.enable = false;
  };
}

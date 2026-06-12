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
    # vboxvideo kernel DRM driver + modesetting Xorg fallback
    services.xserver.videoDrivers = ["modesetting" "virtualbox"];
    # Basic graphics stack
    hardware.graphics.enable = true;
    # Blacklist vmwgfx — it misdetects VBoxSVGA and causes drm errors at boot
    boot.blacklistedKernelModules = ["vmwgfx"];
    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBGL_ALWAYS_SOFTWARE = "1";
      MESA_LOADER_DRIVER_OVERRIDE = "llvmpipe";
      # Allow wlroots compositors to run on software rendering
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
  };
}

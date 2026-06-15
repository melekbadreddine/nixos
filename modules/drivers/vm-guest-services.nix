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
    # VMware guest services
    virtualisation.vmware.guest = {
      enable = true;
      headless = false;
    };

    # VirtualBox guest additions (auto-detects hypervisor)
    virtualisation.virtualbox.guest = {
      enable = true;
      dragAndDrop = true;
      clipboard = true;
    };

    # QEMU / KVM guest services
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    services.xserver.videoDrivers = ["modesetting"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.variables = {
      # Prevent invisible cursors in VMs
      WLR_NO_HARDWARE_CURSORS = "1";

      # Fallback to software rendering if virtual GPU 3D initialization fails
      WLR_RENDERER_ALLOW_SOFTWARE = "1";

      # Fix QtQuick/QML apps (like Noctalia) crashing or failing to render in VMs with 3D acceleration
      QSG_RENDER_LOOP = "basic";

      # Limit virtual GPU to stable OpenGL code paths (uncomment if you still experience black screen)
      # SVGA_VGPU10 = "0";

      # Force software rendering for compositor if virtual GPU is completely broken (uncomment if needed)
      # WLR_RENDERER = "pixman";
    };
  };
}

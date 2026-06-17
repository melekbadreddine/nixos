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
    boot.blacklistedKernelModules = ["i2c_piix4"];
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      "kernel.nmi_watchdog" = 0;
    };

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
      WLR_NO_HARDWARE_CURSORS = "1";
      # Fix Ghostty and all GTK4 apps failing to acquire OpenGL context
      GSK_RENDERER = "cairo";
      LIBGL_ALWAYS_SOFTWARE = "1";
      # Fix QtQuick/QML apps in VM
      QSG_RENDER_LOOP = "basic";
      SVGA_VGPU10 = "0";
    };
  };
}

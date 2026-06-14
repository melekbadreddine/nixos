{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (!(config.wsl.enable or false)) {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    boot.kernelParams = [
      "quiet"
      # "splash"
      # "boot.shell_on_fail"
      "loglevel=3"
      "udev.log_priority=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
      "usbcore.autosuspend=-1"
    ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    boot.plymouth.enable = false;
    boot.blacklistedKernelModules = ["i2c_piix4"];
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      "kernel.nmi_watchdog" = 0;
    };
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}

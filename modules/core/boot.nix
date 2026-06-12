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
      "splash"
      "loglevel=3"
      "udev.log_priority=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
      "boot.shell_on_fail"
      "usbcore.autosuspend=-1"
    ];

    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;

    # Boot animation / splash screen
    boot.plymouth.enable = true;

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

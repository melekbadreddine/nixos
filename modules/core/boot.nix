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
      "boot.shell_on_fail"
      "loglevel=3"
      "udev.log_priority=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
      "usbcore.autosuspend=-1"
    ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    boot.plymouth.enable = true;

    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}

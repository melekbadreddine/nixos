{ ... }: {
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel boot parameters for improved boot experience
  boot.kernelParams = [
    "usbcore.autosuspend=-1" # Prevent USB hub hang
    "iommu=soft" # Enable IOMMU for better hardware support
    "quiet" # Suppress verbose boot output
    "splash" # Show splash screen during boot
    "boot.shell_on_fail" # Drop to shell on boot failure
    "loglevel=3" # Reduce kernel log verbosity
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Boot animation / splash screen
  boot.plymouth.enable = true;
}

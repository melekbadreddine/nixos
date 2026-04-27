{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Prevent USB hub hang
  boot.kernelParams [ 
    "usbcore.autosuspend=-1" 
    "iommu=soft" 
  ];
  
  # Boot Animation / Splash Screen.
  boot.plymouth.enable = true;
}

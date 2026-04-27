{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/boot.nix
      ../../modules/i18n.nix
      ../../modules/users.nix
      ../../modules/virtualisation.nix
      ../../modules/fonts.nix
      ../../modules/desktops/default.nix
      ../../modules/sound.nix
      ../../modules/printing.nix
      ../../modules/networking.nix
      ../../modules/core.nix
      ../../modules/stylix.nix
    ];

  networking.hostName = "Melek"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.k3s.enable = true;
  system.stateVersion = "25.05"; # Did you read the comment?
}

{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktops/default.nix
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

  system.stateVersion = "25.11"; # Did you read the comment?
}

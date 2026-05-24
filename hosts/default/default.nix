{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktops/default.nix
  ];

  networking.hostName = "Melek";
}

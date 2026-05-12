{ ... }:

{
  imports =
    [ 
      ../../modules/core
      ../../modules/desktops/default.nix
    ];

  networking.hostName = "Melek";

  system.stateVersion = "25.11";
}

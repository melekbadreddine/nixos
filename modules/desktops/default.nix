{ config, pkgs, ... }:

{
  imports = [
    # ./cosmic.nix
    ./kde.nix
    # ./xfce.nix
  ];
}

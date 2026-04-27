{ config, pkgs, ... }:

{
  imports = [
    # ./cosmic.nix
    ./plasma.nix
    # ./xfce.nix
  ];
}

{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.k3s.enable = true;
  systemd.services.k3s.wantedBy = lib.mkForce [ ];
}

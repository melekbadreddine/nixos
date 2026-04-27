{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.k3s.enable = true;
  services.k3s.autoStart = false;
}

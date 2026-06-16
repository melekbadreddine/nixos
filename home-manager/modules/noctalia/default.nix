{
  config,
  inputs,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;
    systemd.enable = false; # auto-restart on config change
    settings = import ./config.nix {inherit colors;};
  };
}

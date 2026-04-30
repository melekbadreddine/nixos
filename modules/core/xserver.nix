{ config, pkgs, ... }:

{
  # X server keyboard configuration for French layout
  services.xserver = {
    xkb.layout = "fr";
    xkb.variant = "";
    xkb.options = "";
  };
}

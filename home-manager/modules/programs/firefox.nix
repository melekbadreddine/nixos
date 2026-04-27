{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    # Adopt the new XDG path to clear the warning
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}

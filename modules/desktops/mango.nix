{ lib, pkgs, ... }:

{
  # ===== SYSTEM-LEVEL CONFIGURATION =====
  services.gvfs.enable = true;
  programs.dconf.enable = true;

  # Login manager with Mango support
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd mango";
        user = "greeter";
      };
    };
  };

  # Required system services for Wayland/Mango
  services.libinput.enable = true;
}

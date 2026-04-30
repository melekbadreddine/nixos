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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd mango";
        user = "greeter";
      };
    };
  };

  # Enable the Mango compositor at system level to register it properly
  programs.mango.enable = true;

  # Required system services for Wayland/Mango
  services.libinput.enable = true;
  services.dbus.enable = true;
}

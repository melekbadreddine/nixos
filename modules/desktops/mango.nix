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
        # Using bash --login to source /etc/profile and PAM environments
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'bash --login -c mango'";
        user = "greeter";
      };
    };
  };

  # XDG Portals for Wayland support
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Enable the Mango compositor at system level to register it properly
  programs.mangowc.enable = true;

  # Required system services for Wayland/Mango
  services.libinput.enable = true;
  services.dbus.enable = true;
}

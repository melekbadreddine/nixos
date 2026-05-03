{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.vm.guest-services;
in {
  options.vm.guest-services = {
    enable = mkEnableOption "Enable Virtual Machine Guest Services";
  };

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    # VirtualBox Guest Additions
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.dragAndDrop = true;

    # spice-webdavd is disabled due to build failure with davsfs2 (unsupported neon version)
    # Enable if your system doesn't encounter this issue
    services.spice-webdavd.enable = false;
  };
}

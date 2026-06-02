{...}: {
  services = {
    # High-performance system console config (Replaces default getty)
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-name=JetBrainsMono Nerd Font
      '';
    };

    # X server keyboard configuration for French layout
    xserver = {
      enable = true;
      xkb = {
        layout = "fr";
        variant = "azerty";
        options = "";
      };
    };

    # DESKTOP INFRASTRUCTURE
    gvfs.enable = true; # Virtual file system support (USB auto-mount, Trash bin)
    gnome.gnome-keyring.enable = true; # Safe credential storage for Git/SSH
    dbus.enable = true; # Inter-process desktop communications

    # Enable sound with pipewire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable CUPS to print documents
    printing.enable = true;
  };

  # SYSTEMD OPTIMIZATIONS
  systemd.services.NetworkManager-wait-online.enable = false; # Fast boot times
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s"; # Fast shutdown times
}

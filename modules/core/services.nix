{...}: {
  services = {
    # X server keyboard configuration for French layout
    xserver = {
      xkb = {
        layout = "fr";
        variant = "azerty";
        options = "";
      };
    };

    # Enable sound with pipewire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };

    # Enable CUPS to print documents
    printing.enable = true;
  };
}

{...}: {
  # Enable the SDDM Display Manager.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}

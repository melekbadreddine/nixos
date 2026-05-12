{...}: {
  # Disable automatic styling in Home Manager to prevent conflicts with Plasma 6.
  # Manual themes (Starship, Ghostty, etc.) are handled in their respective modules.
  stylix.autoEnable = false;

  stylix.targets = {
    starship.enable = false;
    ghostty.enable = false;
    fish.enable = false;
  };

  gtk.gtk4.theme = null;
}

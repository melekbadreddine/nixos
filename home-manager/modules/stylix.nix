{ ... }: {
  # Enable automatic styling so Stylix handles the wallpaper and general theme
  stylix.autoEnable = true;

  stylix.targets = {
    # Specifically disable these to preserve manual configurations
    firefox.enable = false;
    starship.enable = false;
    kitty.enable = false;
    fish.enable = false;
  };
}
{pkgs, ...}: {
  services.desktopManager.cosmic.enable = true;

  # Remove bloat
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-store
    firefox-unwrapped
  ];

  # Force Stylix/COSMIC wallpaper integration if needed
  # COSMIC often uses its own background management, but we can hint it here
}

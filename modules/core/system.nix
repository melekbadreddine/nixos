{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Global Behavior & Performance Optimizations
  documentation.nixos.enable = false;

  # Prevents fish from causing long build times
  documentation.man.cache.enable = false;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Windows compatibility layer
    wineWow64Packages.stable
    winetricks
  ];
}

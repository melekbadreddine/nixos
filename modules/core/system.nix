{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Windows compatibility layer
    wineWow64Packages.stable
    winetricks
  ];
}

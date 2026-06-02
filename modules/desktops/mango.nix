{
  pkgs,
  mango,
  ...
}: {
  environment.systemPackages = [
    mango.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Register Mango as a session for the display manager
  services.displayManager.sessionPackages = [
    mango.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

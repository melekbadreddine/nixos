{
  pkgs,
  mango,
  ...
}: let
  mango-nightly = mango.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Manually create the session file since the package doesn't provide it
  mango-session = pkgs.writeTextFile {
    name = "mango-session";
    destination = "/share/wayland-sessions/mango.desktop";
    text = ''
      [Desktop Entry]
      Name=Mango
      Comment=Mango Wayland Compositor
      Exec=${mango-nightly}/bin/mango
      Type=Application
    '';
    # Required by NixOS to recognize the session
    passthru.providedSessions = ["mango"];
  };
in {
  environment.systemPackages = [
    mango-nightly
    mango-session
  ];

  # Register Mango as a session for the display manager
  services.displayManager.sessionPackages = [
    mango-session
  ];
}

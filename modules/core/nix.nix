{...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      "https://melek-nixos.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "melek-nixos.cachix.org-1:UdhKZAFc78C4ge9SFfgCtMcyBGVfJemC/dwjBaqonVs="
    ];
    trusted-users = ["root" "@wheel"];
    connect-timeout = 60;
    stalled-download-timeout = 300;
    download-attempts = 5;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

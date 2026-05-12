{...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org"
      "https://melek-nixos.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "melek-nixos-1:UdhKZAFc78C4ge9SFfgCtMcyBGVfJemC/dwjBaqonVs="
    ];
    trusted-users = ["root" "@wheel"];
  };
}

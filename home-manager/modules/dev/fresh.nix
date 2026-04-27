{ pkgs, fresh, ... }: {
  home.packages = [
    fresh.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

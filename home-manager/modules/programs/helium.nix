{ pkgs, helium, ... }: {
  home.packages = [ 
    helium.packages.${pkgs.stdenv.hostPlatform.system}.default 
  ];
}

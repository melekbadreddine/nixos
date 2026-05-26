{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "waybar-gen" ''
      echo "Waybar config is now managed by Home Manager in NixOS config."
      echo "Source: home-manager/modules/waybar/config.nix"
    '')
  ];
}

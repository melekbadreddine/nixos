{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "mango-nixos-logo" ''
      echo "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"
    '')
  ];
}

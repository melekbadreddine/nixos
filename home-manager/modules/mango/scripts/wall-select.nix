{pkgs, ...}: {
  home.packages = [
    (pkgs.writers.writePython3Bin "wall-select" {
      libraries = with pkgs.python3Packages; [pygobject3];
    } (builtins.readFile ./wall-select.py))
  ];
}

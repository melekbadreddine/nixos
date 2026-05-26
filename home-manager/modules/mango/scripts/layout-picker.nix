{pkgs, ...}: {
  home.packages = [
    (pkgs.writers.writePython3Bin "layout-picker" {
      libraries = with pkgs.python3Packages; [pygobject3];
    } (builtins.readFile ./layout-picker.py))
  ];
}

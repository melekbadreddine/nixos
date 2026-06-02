{
  vars,
  pkgs,
  ...
}: {
  stylix.enable = vars.stylixEnable;
  stylix.image = vars.stylixImage;
  stylix.base16Scheme = pkgs.base16-schemes + "/share/themes/catppuccin-mocha.yaml";

  stylix.autoEnable = false;

  stylix.targets = {
    starship.enable = false;
    ghostty.enable = false;
    fish.enable = false;
  };
}

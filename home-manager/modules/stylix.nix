{
  vars,
  pkgs,
  ...
}: {
  stylix.enable = true;
  stylix.enableReleaseChecks = false;
  stylix.image = vars.stylixImage;
  stylix.base16Scheme = pkgs.base16-schemes + "/share/themes/catppuccin-mocha.yaml";

  # Enable automatic theming for user apps generally
  stylix.autoEnable = true;

  # Explicitly disable for specific apps where you have manual config
  stylix.targets = {
    starship.enable = false;
    ghostty.enable = false;
    fish.enable = false;
  };
}

{
  config,
  noctalia,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  imports = [noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;
    # Pass settings as a Nix attrset — HM module serialises to TOML
    settings = import ./config.nix {inherit colors;};
  };
}

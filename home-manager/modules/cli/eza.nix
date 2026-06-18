{...}: let
  sharedAliases = {
    lsd = "eza -lD";
    lsf = "eza -lf";
    lstr = "eza -l --sort=time";
    tree = "eza --tree --no-user --no-permissions --no-filesize";
  };
in {
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    icons = "always";
    extraOptions = ["--color=always"];
  };

  programs.bash.shellAliases = sharedAliases;
  programs.fish.shellAliases = sharedAliases;
}

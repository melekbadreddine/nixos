{ pkgs, ... }: {
  home.packages = with pkgs; [
    nautilus
    navi
    cht-sh
  ];

  programs.bash.shellAliases = {
    "?" = "cht.sh";
  };
}

{ ... }: {
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "always";
    extraOptions = [ "--color=always" ];
  };
  programs.bash.shellAliases = {
    ls = "eza --icons=always --color=always";
    la = "eza -a --icons=always --color=always";
    ll = "eza -alF --icons=always --color=always";
    lsd = "eza -lD --icons=always --color=always";
    lsf = "eza -lf --icons=always --color=always";
    lstr = "eza -l --sort=time --icons=always --color=always";
    tree = "eza --tree --no-user --no-permissions --no-filesize --icons=always --color=always";
  };
}

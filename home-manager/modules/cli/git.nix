{pkgs, ...}: {
  home.packages = with pkgs; [
    gh
    glab
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "melekbadreddine";
        email = "mbadreddine5@gmail.com";
      };

      init.defaultBranch = "main";

      credential = {
        "https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
        "https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
        "https://gitlab.com".helper = "!${pkgs.glab}/bin/glab auth git-credential";
        helper = "store";
      };

      merge.conflictstyle = "zdiff3";

      diff.colorMoved = "default";

      push.autoSetupRemote = true;

      diff.lockb = {
        textconv = "bun";
        binary = true;
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "decorations";
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      interactive.keep-plus-minus-markers = false;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  services.ssh-agent.enable = true;

  programs.lazygit.enable = true;
}

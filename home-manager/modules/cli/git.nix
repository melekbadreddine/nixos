{ pkgs, osConfig, ... }: {
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "melekbadreddine";
        email = "mbadreddine5@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
      credential = {
        helper = ''!f() { [ "$1" = "get" ] && echo "username=melekbadreddine" && echo "password=$(cat ${osConfig.sops.secrets."github/token".path})"; }; f'';
      };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.lazygit.enable = true;
}

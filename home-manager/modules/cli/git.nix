{osConfig ? null, ...}: let
  sopsPath =
    if osConfig != null && osConfig ? sops
    then osConfig.sops.secrets."github/token".path
    else "/run/secrets/github/token";
in {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "melekbadreddine";
        email = "mbadreddine5@gmail.com";
      };

      init.defaultBranch = "main";

      credential.helper = ''!f() { [ "$1" = "get" ] && printf "username=melekbadreddine\npassword=$(cat ${sopsPath})\n"; }; f "$@"'';

      merge.conflictstyle = "zdiff3";

      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.lazygit.enable = true;
}

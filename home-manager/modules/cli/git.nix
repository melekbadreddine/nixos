{osConfig, ...}: let
  # Fallback to the default NixOS SOPS path if osConfig is not available (e.g., in standalone HM build)
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
      init = {
        defaultBranch = "main";
      };
      credential = {
        helper = ''!f() { [ "$1" = "get" ] && echo "username=melekbadreddine" && echo "password=$(cat ${sopsPath})"; }; f'';
      };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.lazygit.enable = true;
}

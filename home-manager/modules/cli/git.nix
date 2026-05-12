{osConfig, ...}: let
  sopsPath =
    if osConfig != null && osConfig ? sops
    then osConfig.sops.secrets."github/token".path
    # Fallback path for NixOS-managed Home Manager where SOPS is guaranteed to provision the secret.
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
    };
  };

  programs.lazygit.enable = true;
}

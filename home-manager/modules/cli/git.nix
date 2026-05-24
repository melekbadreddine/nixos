{
  osConfig ? null,
  lib,
  ...
}: let
  # Use osConfig if available (NixOS managed), otherwise check for the path, or use a dummy for evaluation safety
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
      credential.helper = lib.mkIf (builtins.pathExists sopsPath) ''!f() { [ "$1" = "get" ] && printf "username=melekbadreddine\npassword=$(cat ${sopsPath})\n"; }; f "$@"'';
    };
  };

  programs.lazygit.enable = true;
}

{ ... }: {
  home.sessionVariables = { _ZO_DOCTOR = "0"; };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}

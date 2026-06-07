{
  pkgs,
  inputs,
  ...
}: let
  sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    theme = "silvia";
  };
in {
  environment.systemPackages = [sddm-theme sddm-theme.test];
  qt.enable = true;
  services.displayManager.sddm = {
    extraPackages = sddm-theme.propagatedBuildInputs ++ [pkgs.phinger-cursors];
    package = pkgs.kdePackages.sddm; # use qt6 version of sddm
    enable = true;
    theme = sddm-theme.pname;
    wayland.enable = true;
    settings = {
      General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard,XCURSOR_THEME=phinger-cursors-dark";
        InputMethod = "qtvirtualkeyboard";
      };
      Theme = {
        CursorTheme = "phinger-cursors-dark";
      };
    };
  };
}

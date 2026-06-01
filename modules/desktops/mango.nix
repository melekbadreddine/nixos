{pkgs, ...}: let
  mango-wrapped = pkgs.symlinkJoin {
    name = "mango-wrapped";
    paths = [pkgs.mangowc];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/mango \
        --add-flags "-s /home/melek/.config/mango/autostart.sh"
    '';
    passthru.providedSessions = ["mango"];
  };
in {
  programs.mangowc = {
    enable = true;
    package = mango-wrapped;
  };

  environment.systemPackages = with pkgs; [
    quickshell
    rofi
    dunst
    awww
    hyprpolkitagent
    cliphist
    wl-clipboard
    grim
    slurp
    libnotify
    upower
  ];

  services.upower.enable = true;
}

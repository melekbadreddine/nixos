{pkgs, ...}: let
  mango-wrapped = pkgs.symlinkJoin {
    name = "mango-wrapped";
    paths = [pkgs.mangowc];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/mango \
        --add-flags "-s /home/melek/.config/mango/autostart.sh"
    '';
  };
in {
  programs.mangowc = {
    enable = true;
    package = mango-wrapped;
  };

  # Explicitly ensure the wrapped package is used for portals too
  # although the module already adds cfg.package to systemPackages

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

  # Portal configuration is already handled by programs.mangowc.enable
  # But we can add extraPortals if needed. The module already adds wlr and gtk.
}

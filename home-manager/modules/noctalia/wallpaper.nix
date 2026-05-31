{
  pkgs,
  vars,
  ...
}: {
  systemd.user.services.awww = {
    Unit = {
      Description = "awww wallpaper daemon";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  home.activation.setWallpaper = {
    after = ["writeBoundary"];
    before = [];
    data = ''
      ${pkgs.awww}/bin/awww img ${vars.stylixImage}
    '';
  };
}

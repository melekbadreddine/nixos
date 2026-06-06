{pkgs, ...}: {
  # 1. Core system-level Polkit actions framework enablement
  security.polkit.enable = true;

  # 2. System-wide profile packages
  environment.systemPackages = with pkgs; [
    polkit
    polkit_gnome
  ];

  # 3. Handle graphical user session privileges initialization
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        # Safe universal compilation lookup for the modern binary path
        ExecStart = "${pkgs.polkit_gnome}/lib/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Global system shutdown optimizations
    settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}

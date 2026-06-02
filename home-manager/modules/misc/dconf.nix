{lib, ...}: {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkForce "prefer-dark";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      enable-animations = true;
    };
  };
}

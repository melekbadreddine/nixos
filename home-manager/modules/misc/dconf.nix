{lib, ...}: {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = lib.mkDefault "Graphite-Dark";
      icon-theme = lib.mkDefault "Tela-dark";
      cursor-theme = lib.mkDefault "Macintosh";
      cursor-size = lib.mkDefault 24;
      color-scheme = lib.mkDefault "prefer-dark";
    };
  };
}

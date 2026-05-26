{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };
    iconTheme = {
      name = "Tela-dark";
      package = pkgs.tela-icon-theme;
    };
    cursorTheme = {
      name = "Macintosh";
      package = pkgs.apple-cursor;
      size = 24;
    };
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = true;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = true;};
    gtk4.theme = config.gtk.theme; # Silences warning
  };
  home.sessionVariables.GTK_THEME = "Graphite-Dark";
}

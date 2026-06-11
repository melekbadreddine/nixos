{
  config,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors;

  # Helper: produce an 8-digit hex color with full opacity for rofi
  hex = c: "#${c}";
  hexAlpha = c: a: "#${c}${a}"; # a = 2-char alpha e.g. "cc"
in {
  programs.rofi = {
    enable = true;
    # Rofi Wayland is now merged into standard rofi package
    package = pkgs.rofi;

    extraConfig = {
      modi = "drun,run,filebrowser";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      terminal = "${pkgs.ghostty}/bin/ghostty";
      drun-display-format = "{name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "  Apps";
      display-run = "  Run";
      display-filebrowser = "  Files";
      sidebar-mode = true;
    };

    theme = "${./config.rasi}";
  };

  # Write colors.rasi to the user's config directory so the theme can import it
  xdg.configFile."rofi/colors.rasi".text = ''
    * {
      bg0: ${hexAlpha colors.base00 "e6"};
      bg1: ${hex colors.base01};
      bg2: ${hex colors.base02};
      fg0: ${hex colors.base05};
      fg1: ${hex colors.base04};
      accent: ${hex colors.base0D};
      urgent: ${hex colors.base08};
      transparent: #00000000;
    }
  '';

  # Papirus icon theme for rofi icons
  home.packages = with pkgs; [
    papirus-icon-theme
  ];
}

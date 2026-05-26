{
  pkgs,
  config,
  ...
}: let
  # Theme script block helper
  mkTheme = name: colors: ''
    "${name}")
      BG="${colors.bg}"
      FG="${colors.fg}"
      PRIMARY="${colors.primary}"
      SECONDARY="${colors.secondary}"
      TERTIARY="${colors.tertiary}"
      ACCENT="${colors.accent}"
      ERROR="${colors.error}"
      SURFACE="${colors.surface}"
      OUTLINE="${colors.outline}"
      SHADOW="${colors.shadow}"
      WARNING="${colors.warning}"
      SUCCESS="${colors.success}"
      HOVER="${colors.hover}"
      BG_ALT="${colors.bg_alt}"
      GTK_THEME="${colors.gtk_theme}"
      ICON_THEME="${colors.icon_theme}"
      ;;
  '';

  # Catppuccin Mocha colors from Stylix (default)
  mocha = {
    bg = "#${config.lib.stylix.colors.base00}";
    fg = "#${config.lib.stylix.colors.base05}";
    primary = "#${config.lib.stylix.colors.base0D}";
    secondary = "#${config.lib.stylix.colors.base0E}";
    tertiary = "#${config.lib.stylix.colors.base0C}";
    accent = "#${config.lib.stylix.colors.base0B}";
    error = "#${config.lib.stylix.colors.base08}";
    surface = "#${config.lib.stylix.colors.base01}";
    outline = "#${config.lib.stylix.colors.base02}";
    shadow = "#${config.lib.stylix.colors.base00}";
    warning = "#${config.lib.stylix.colors.base0A}";
    success = "#${config.lib.stylix.colors.base0B}";
    hover = "#${config.lib.stylix.colors.base02}";
    bg_alt = "#${config.lib.stylix.colors.base01}";
    gtk_theme = "Graphite-Dark";
    icon_theme = "Tela-dark";
  };

  gruvbox = {
    bg = "#282828";
    fg = "#ebdbb2";
    primary = "#ebdbb2";
    secondary = "#8ec07c";
    tertiary = "#83a598";
    accent = "#b8bb26";
    error = "#fb4934";
    surface = "#3c3836";
    outline = "#504945";
    shadow = "#282828";
    warning = "#83a598";
    success = "#8ec07c";
    hover = "#83a598";
    bg_alt = "#1d2021";
    gtk_theme = "Graphite-Dark";
    icon_theme = "Gruvbox-Plus-Dark";
  };

  pink = {
    bg = "#1e1e2e";
    fg = "#cdd6f4";
    primary = "#f5c2e7";
    secondary = "#cba6f7";
    tertiary = "#b4befe";
    accent = "#f5c2e7";
    error = "#f38ba8";
    surface = "#313244";
    outline = "#45475a";
    shadow = "#181825";
    warning = "#f9e2af";
    success = "#a6e3a1";
    hover = "#f5c2e7";
    bg_alt = "#181825";
    gtk_theme = "Graphite-Dark";
    icon_theme = "Tela-pink-dark";
  };

  purple = {
    bg = "#1e1e2e";
    fg = "#cdd6f4";
    primary = "#cba6f7";
    secondary = "#b4befe";
    tertiary = "#f5c2e7";
    accent = "#cba6f7";
    error = "#f38ba8";
    surface = "#313244";
    outline = "#45475a";
    shadow = "#181825";
    warning = "#f9e2af";
    success = "#a6e3a1";
    hover = "#cba6f7";
    bg_alt = "#181825";
    gtk_theme = "Graphite-Dark";
    icon_theme = "Tela-purple-dark";
  };

  monochrome = {
    bg = "#0a0a0a";
    fg = "#e0e0e0";
    primary = "#ffffff";
    secondary = "#b0b0b0";
    tertiary = "#808080";
    accent = "#ffffff";
    error = "#ff4444";
    surface = "#1a1a1a";
    outline = "#333333";
    shadow = "#000000";
    warning = "#ffaa00";
    success = "#44ff44";
    hover = "#2a2a2a";
    bg_alt = "#050505";
    gtk_theme = "Graphite-Dark";
    icon_theme = "Tela-grey-dark";
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "switch-theme" ''
      set -euo pipefail

      CURRENT_THEME_FILE="$HOME/.config/mango/.theme"
      [ -f "$CURRENT_THEME_FILE" ] || echo "catppuccin-mocha" > "$CURRENT_THEME_FILE"
      current_theme=$(cat "$CURRENT_THEME_FILE")

      if [ "''${1:-}" = "--apply" ]; then
          selected="$current_theme"
      else
          selected=$(echo -e "catppuccin-mocha\ngruvbox\ncatppuccin-pink\ncatppuccin-purple\nmonochrome" | ${pkgs.wofi}/bin/wofi -d -p "Themes" -W 300 -H 350 -l center)
          [ -z "$selected" ] && exit 0
      fi

      case "$selected" in
        ${mkTheme "catppuccin-mocha" mocha}
        ${mkTheme "gruvbox" gruvbox}
        ${mkTheme "catppuccin-pink" pink}
        ${mkTheme "catppuccin-purple" purple}
        ${mkTheme "monochrome" monochrome}
      esac

      echo "$selected" > "$CURRENT_THEME_FILE"

      # Apply GTK/Icon/Cursor
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "Macintosh"

      # Apply Wallpaper
      ${pkgs.awww}/bin/awww img "${config.stylix.image}"

      # Mango Colors
      cat > "$HOME/.config/mango/theme-colors.conf" <<EOF
      shadowscolor = ''${BG}ff
      rootcolor = ''${BG}ff
      bordercolor = ''${SURFACE}ff
      focuscolor = ''${ACCENT}ff
      maximizescreencolor = ''${SECONDARY}ff
      urgentcolor = ''${ERROR}ff
      scratchpadcolor = ''${TERTIARY}ff
      globalcolor = ''${WARNING}ff
      overlaycolor = ''${SUCCESS}ff
      EOF

      # Waybar Colors
      mkdir -p "$HOME/.config/waybar"
      cat > "$HOME/.config/waybar/colors.css" <<EOF
      @define-color bg ''${BG};
      @define-color fg ''${FG};
      @define-color accent ''${ACCENT};
      @define-color secondary ''${SECONDARY};
      @define-color tertiary ''${TERTIARY};
      @define-color error ''${ERROR};
      @define-color surface ''${SURFACE};
      @define-color outline ''${OUTLINE};
      @define-color shadow ''${SHADOW};
      @define-color warning ''${WARNING};
      @define-color success ''${SUCCESS};
      @define-color hover ''${HOVER};
      @define-color bg_alt ''${BG_ALT};
      EOF

      # Reload
      mmsg -d reload_config || true
      pkill -USR2 waybar || true
      pkill mako || true
      mako &

      ${pkgs.libnotify}/bin/notify-send "Theme Switched" "Now using: $selected"
    '')

    (pkgs.writeShellScriptBin "mango-reload" ''
      mmsg -d reload_config
      switch-theme --apply
      ${pkgs.libnotify}/bin/notify-send "Mango Reloaded" "Configuration and theme refreshed"
    '')
  ];
}

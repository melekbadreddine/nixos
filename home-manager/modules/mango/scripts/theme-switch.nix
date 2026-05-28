{
  pkgs,
  config,
  ...
}: let
  # Verbatim CSS Template from mango-waybar/bars/full/style.css.template
  # (Converted to Nix string for runtime sed substitution by switch-theme)
  waybarStyleTemplate = ''
    /* ─── Waybar Template ─── */
    /* Colors generated from theme.conf via switch-theme.sh */

    * {
        font-family:
            "JetBrainsMono Nerd Font", "JetBrains Mono", "Font Awesome 6 Free",
            monospace;
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
    }

    /* ─── Main Bar ─── */
    #waybar {
        background-color: rgba(__BG_RGB__, 0.85);
        color: __FG__;
        border-radius: 8px;
        padding: 4px 8px;
    }

    /* ─── Module Sections ─── */
    .modules-left,
    .modules-center,
    .modules-right {
        padding: 0 4px;
    }

    /* ─── Individual Modules ─── */
    #image,
    #tags,
    #window,
    #cpu,
    #temperature,
    #memory,
    #disk,
    #network,
    #tray,
    #custom-notifications,
    #battery,
    #pulseaudio,
    #clock,
    #custom-power,
    #custom-power#vertical {
        padding: 4px 10px;
        margin: 2px 3px;
        border-radius: 8px;
        background-color: transparent;
    }

    /* ─── NixOS Logo (Image) ─── */
    #image,
    #image#nixos {
        padding: 4px 8px;
        margin: 2px 3px;
        border-radius: 8px;
        background-color: transparent;
    }

    /* ─── Workspaces (dwl/tags) ─── */
    #tags,
    #tags#vertical {
        background-color: transparent;
        padding: 2px 6px;
    }

    #tags button,
    #tags#vertical button {
        padding: 2px 7px;
        margin: 0 2px;
        color: __DIM__;
        background-color: transparent;
        border-radius: 6px;
        transition: all 0.2s ease;
    }

    /* Occupied workspace */
    #tags button.occupied,
    #tags#vertical button.occupied {
        color: __YELLOW__;
    }

    /* Empty workspace */
    #tags button.empty,
    #tags#vertical button.empty {
        color: __DIM__;
    }

    /* Focused workspace */
    #tags button.focused,
    #tags button.active,
    #tags#vertical button.focused,
    #tags#vertical button.active {
        color: __BG__;
        background-color: __ACCENT__;
        font-weight: bold;
    }

    /* Urgent workspace */
    #tags button.urgent,
    #tags#vertical button.urgent {
        color: __RED__;
        background-color: rgba(__RED_RGB__, 0.2);
    }

    /* Hover effect */
    #tags button:hover,
    #tags#vertical button:hover {
        background-color: rgba(__ACCENT_RGB__, 0.3);
        color: __FG__;
    }

    #tags button.focused:hover,
    #tags button.active:hover,
    #tags#vertical button.focused:hover,
    #tags#vertical button.active:hover {
        background-color: __ACCENT__;
        color: __BG__;
    }

    /* ─── Active Window (dwl/window) ─── */
    #window {
        color: __FG__;
        background-color: transparent;
    }

    /* ─── Center System Stats ─── */
    #cpu {
        color: __ERROR__;
    }

    #temperature {
        color: __ORANGE__;
    }

    #temperature.critical {
        color: __RED__;
        background-color: rgba(__RED_RGB__, 0.2);
    }

    #memory {
        color: __YELLOW__;
    }

    #disk {
        color: __ACCENT__;
    }

    #network {
        color: __SECONDARY__;
    }

    #network.disconnected {
        color: __BLACKB__;
    }

    /* ─── System Tray ─── */
    #tray {
        background-color: transparent;
        padding: 4px 8px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(__ORANGE_RGB__, 0.3);
    }

    /* ─── Notifications ─── */
    #custom-notifications {
        color: __CYAN__;
    }

    #custom-notifications.has-notifications {
        color: __ERROR__;
    }

    /* ─── Battery ─── */
    #battery {
        color: __CYAN__;
    }

    #battery.warning {
        color: __YELLOW__;
    }

    #battery.critical {
        color: __RED__;
    }

    #battery.charging,
    #battery.plugged {
        color: __ACCENT__;
    }

    /* ─── Pulseaudio ─── */
    #pulseaudio {
        color: __TERTIARY__;
    }

    #pulseaudio.muted {
        color: __BLACKB__;
    }

    /* ─── Clock ─── */
    #clock,
    #clock#vertical {
        color: __FG__;
        background-color: transparent;
        font-weight: 600;
    }

    /* ─── Power Button ─── */
    #custom-power,
    #custom-power#vertical {
        color: __ERROR__;
        background-color: transparent;
        font-size: 14px;
        padding: 2px 12px;
    }

    #custom-power:hover,
    #custom-power#vertical:hover {
        background-color: rgba(__ERROR_RGB__, 0.15);
    }

    /* ─── Tooltip ─── */
    tooltip {
        background-color: rgba(__BG_RGB__, 0.95);
        border: 1px solid rgba(__OUTLINE_RGB__, 0.8);
        border-radius: 8px;
        padding: 8px;
    }

    tooltip label {
        color: __FG__;
        padding: 4px;
    }
  '';

  # Theme definitions exactly as found in theme.conf files
  # (Including Catppuccin Mocha for default)
  mocha = {
    BG = "#1e1e2e";
    FG = "#cdd6f4";
    PRIMARY = "#cba6f7";
    SECONDARY = "#f5c2e7";
    TERTIARY = "#89b4fa";
    ACCENT = "#cba6f7";
    ERROR = "#f38ba8";
    SURFACE = "#313244";
    OUTLINE = "#45475a";
    SHADOW = "#11111b";
    ORANGE = "#fab387";
    DIM = "#6c7086";
    BLACK = "#181825";
    RED = "#f38ba8";
    GREEN = "#a6e3a1";
    YELLOW = "#f9e2af";
    BLUE = "#89b4fa";
    MAGENTA = "#cba6f7";
    CYAN = "#89dceb";
    WHITE = "#cdd6f4";
    BLACKB = "#313244";
    REDB = "#f38ba8";
    GREENB = "#a6e3a1";
    YELLOWB = "#f9e2af";
    BLUEB = "#89b4fa";
    MAGENTAB = "#cba6f7";
    CYANB = "#94e2d5";
    WHITEB = "#a6adc8";
    GTK_THEME = "Graphite-Dark";
    ICON_THEME = "Tela-dark";
    CURSOR_THEME = "Macintosh";
    CURSOR_SIZE = "24";
    GTK_FONT = "DepartureMono Nerd Font 11";
    MANGO_BORDER_FOCUSED = "#cba6f7";
  };

  gruvbox = {
    BG = "#282828";
    FG = "#ebdbb2";
    PRIMARY = "#ebdbb2";
    SECONDARY = "#8ec07c";
    TERTIARY = "#83a598";
    ACCENT = "#b8bb26";
    ERROR = "#fb4934";
    SURFACE = "#3c3836";
    OUTLINE = "#504945";
    SHADOW = "#282828";
    ORANGE = "#fe8019";
    DIM = "#665c54";
    BLACK = "#282828";
    RED = "#cc241d";
    GREEN = "#98971a";
    YELLOW = "#d79921";
    BLUE = "#458588";
    MAGENTA = "#b16286";
    CYAN = "#689d6a";
    WHITE = "#a89984";
    BLACKB = "#928374";
    REDB = "#fb4934";
    GREENB = "#b8bb26";
    YELLOWB = "#fabd2f";
    BLUEB = "#83a598";
    MAGENTAB = "#d3869b";
    CYANB = "#8ec07c";
    WHITEB = "#ebdbb2";
    GTK_THEME = "Graphite-Dark";
    ICON_THEME = "Gruvbox-Plus-Dark";
    CURSOR_THEME = "Macintosh";
    CURSOR_SIZE = "24";
    GTK_FONT = "DepartureMono Nerd Font 11";
    MANGO_BORDER_FOCUSED = "#b8bb26";
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
          selected=$(echo -e "catppuccin-mocha\ngruvbox" | ${pkgs.wofi}/bin/wofi -d -p "Themes" -W 300 -H 350 -l center)
          [ -z "$selected" ] && exit 0
      fi

      # Source theme variables (Verbatim translation of switch-theme.sh cases)
      case "$selected" in
        "catppuccin-mocha")
          ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: "${name}=\"${value}\"") mocha)}
          ;;
        "gruvbox")
          ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: value: "${name}=\"${value}\"") gruvbox)}
          ;;
      esac

      echo "$selected" > "$CURRENT_THEME_FILE"

      # Helper: hex to RGB (0,0,0)
      hex_to_rgb() {
          local hex="''${1#\#}"
          echo "$((16#''${hex:0:2})),$((16#''${hex:2:2})),$((16#''${hex:4:2}))"
      }

      BG_RGB=$(hex_to_rgb "$BG")
      ACCENT_RGB=$(hex_to_rgb "$ACCENT")
      RED_RGB=$(hex_to_rgb "$RED")
      ORANGE_RGB=$(hex_to_rgb "$ORANGE")
      OUTLINE_RGB=$(hex_to_rgb "$OUTLINE")

      # Apply Waybar Style verbatim via sed
      mkdir -p "$HOME/.config/waybar"
      echo '${waybarStyleTemplate}' | ${pkgs.gnused}/bin/sed \
          -e "s|__BG__|''${BG}|g" \
          -e "s|__FG__|''${FG}|g" \
          -e "s|__PRIMARY__|''${PRIMARY}|g" \
          -e "s|__SECONDARY__|''${SECONDARY}|g" \
          -e "s|__TERTIARY__|''${TERTIARY}|g" \
          -e "s|__ACCENT__|''${ACCENT}|g" \
          -e "s|__ERROR__|''${ERROR}|g" \
          -e "s|__SURFACE__|''${SURFACE}|g" \
          -e "s|__OUTLINE__|''${OUTLINE}|g" \
          -e "s|__SHADOW__|''${SHADOW}|g" \
          -e "s|__WARNING__|''${YELLOW}|g" \
          -e "s|__SUCCESS__|''${GREEN}|g" \
          -e "s|__HOVER__|''${SURFACE}|g" \
          -e "s|__BG_ALT__|''${SURFACE}|g" \
          -e "s|__ORANGE__|''${ORANGE}|g" \
          -e "s|__DIM__|''${DIM}|g" \
          -e "s|__BLACK__|''${BLACK}|g" \
          -e "s|__RED__|''${RED}|g" \
          -e "s|__GREEN__|''${GREEN}|g" \
          -e "s|__YELLOW__|''${YELLOW}|g" \
          -e "s|__BLUE__|''${BLUE}|g" \
          -e "s|__MAGENTA__|''${MAGENTA}|g" \
          -e "s|__CYAN__|''${CYAN}|g" \
          -e "s|__WHITE__|''${WHITE}|g" \
          -e "s|__BLACKB__|''${BLACKB}|g" \
          -e "s|__REDB__|''${REDB}|g" \
          -e "s|__GREENB__|''${GREENB}|g" \
          -e "s|__YELLOWB__|''${YELLOWB}|g" \
          -e "s|__BLUEB__|''${BLUEB}|g" \
          -e "s|__MAGENTAB__|''${MAGENTAB}|g" \
          -e "s|__CYANB__|''${CYANB}|g" \
          -e "s|__WHITEB__|''${WHITEB}|g" \
          -e "s|__BG_RGB__|''${BG_RGB}|g" \
          -e "s|__ACCENT_RGB__|''${ACCENT_RGB}|g" \
          -e "s|__RED_RGB__|''${RED_RGB}|g" \
          -e "s|__ORANGE_RGB__|''${ORANGE_RGB}|g" \
          -e "s|__OUTLINE_RGB__|''${OUTLINE_RGB}|g" \
          > "$HOME/.config/waybar/style.css"

      # Apply GTK Settings
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"

      # Set Wallpaper via awww
      ${pkgs.awww}/bin/awww img "${config.stylix.image}"

      # Mango Colors
      hex_to_mango() { local hex="''${1#\#}"; echo "0x''${hex}ff"; }
      cat > "$HOME/.config/mango/theme-colors.conf" <<EOF
      shadowscolor = $(hex_to_mango "''${BG}")
      rootcolor = $(hex_to_mango "''${BG}")
      bordercolor = $(hex_to_mango "''${SURFACE}")
      focuscolor = $(hex_to_mango "''${MANGO_BORDER_FOCUSED}")
      maximizescreencolor = $(hex_to_mango "''${SECONDARY}")
      urgentcolor = $(hex_to_mango "''${ERROR}")
      scratchpadcolor = $(hex_to_mango "''${TERTIARY}")
      globalcolor = $(hex_to_mango "''${YELLOW}")
      overlaycolor = $(hex_to_mango "''${GREEN}")
      EOF

      # Hot-reload
      mmsg -d reload_config || true
      pkill -USR2 waybar || true
      pkill mako || true
      mako &

      ${pkgs.libnotify}/bin/notify-send "Theme Switched" "Now using: $selected"
    '')

    (pkgs.writeShellScriptBin "mango-reload" ''
      mmsg -d reload_config
      switch-theme --apply
      ${pkgs.libnotify}/bin/notify-send "Mango Reloaded" "Refreshed"
    '')
  ];
}

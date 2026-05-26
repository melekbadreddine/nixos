{
  pkgs,
  config,
  ...
}: let
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

    (pkgs.writers.writePython3Bin "wall-select" {
        libraries = with pkgs.python3Packages; [pygobject3];
      } ''
        import gi
        gi.require_version("Gtk", "3.0")
        gi.require_version("Gdk", "3.0")
        gi.require_version("GdkPixbuf", "2.0")
        import os, subprocess, sys
        from gi.repository import Gdk, GdkPixbuf, Gtk, Pango

        WALL_DIR = os.path.expanduser("~/nixos/assets/wallpapers")
        DISPLAY_SIZE, SPACING, BORDER_WIDTH = 350, 16, 4
        BG_COLOR, TEXT_COLOR, TEXT_DIM, CARD_BG, CARD_SELECTED = "#1d2021", "#ebdbb2", "#a89984", "#282828", "#3c3836"

        class WallpaperThumb(Gtk.EventBox):
            def __init__(self, filepath, filename, window):
                super().__init__()
                self.filepath, self.filename, self.window, self.is_selected = filepath, filename, window, False
                self.set_size_request(DISPLAY_SIZE, DISPLAY_SIZE)
                self.image = Gtk.Image()
                self.image.set_size_request(DISPLAY_SIZE, DISPLAY_SIZE)
                try:
                    pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(filepath, DISPLAY_SIZE, DISPLAY_SIZE, False)
                    self.image.set_from_pixbuf(pixbuf)
                except: self.image.set_from_icon_name("image-missing", Gtk.IconSize.DIALOG)
                self.add(self.image); self._update_style()
                self.connect("button-press-event", self.on_click)
                self.set_events(Gdk.EventMask.BUTTON_PRESS_MASK)
            def _update_style(self):
                bg = CARD_SELECTED if self.is_selected else CARD_BG
                self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(bg))
                self.set_border_width(BORDER_WIDTH if self.is_selected else 0)
            def on_click(self, w, e):
                if e.button == 1: self.window.select_by_thumb(self); self.window.apply_selected()
                return True
            def set_selected(self, s): self.is_selected = s; self._update_style()

        class WallpaperPicker(Gtk.Window):
            def __init__(self):
                super().__init__(title="Select Wallpaper")
                self.set_decorated(False); self.set_resizable(False); self.set_position(Gtk.WindowPosition.CENTER); self.set_keep_above(True); self.set_type_hint(Gdk.WindowTypeHint.UTILITY)
                self.selected_idx, self.thumbs = -1, []
                main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
                main.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(BG_COLOR))
                # Avoid nested single quotes
                title_lbl = Gtk.Label(label="Select Wallpaper")
                title_lbl.modify_font(Pango.FontDescription("JetBrains Mono Bold 16"))
                title_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
                main.pack_start(title_lbl, False, False, 10)
                hint_lbl = Gtk.Label(label="Arrows to navigate · Enter to apply · Escape to cancel")
                hint_lbl.modify_font(Pango.FontDescription("JetBrains Mono 10"))
                hint_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_DIM))
                main.pack_start(hint_lbl, False, False, 10)
                scrolled = Gtk.ScrolledWindow()
                scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER)
                self.hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=SPACING)
                scrolled.add(self.hbox); main.pack_start(scrolled, True, True, 0); self.add(main)
                screen = Gdk.Screen.get_default()
                self.set_size_request(min(int(screen.get_width() * 0.95), 1800), 500)
                self.connect("key-press-event", self.on_key); self.connect("destroy", Gtk.main_quit); self._populate(); self.show_all()
                if self.thumbs: self.select_by_index(0)
            def _populate(self):
                if not os.path.exists(WALL_DIR): return
                walls = sorted([f for f in os.listdir(WALL_DIR) if f.lower().endswith((".jpg", ".jpeg", ".png", ".webp"))])
                for idx, f in enumerate(walls):
                    thumb = WallpaperThumb(os.path.join(WALL_DIR, f), f, self)
                    thumb.idx = idx; self.hbox.pack_start(thumb, False, False, 0); self.thumbs.append(thumb)
            def select_by_index(self, idx):
                if not self.thumbs: return
                idx = idx % len(self.thumbs)
                if 0 <= self.selected_idx < len(self.thumbs): self.thumbs[self.selected_idx].set_selected(False)
                self.selected_idx = idx; self.thumbs[idx].set_selected(True)
            def select_by_thumb(self, t): self.select_by_index(t.idx)
            def apply_selected(self):
                if 0 <= self.selected_idx < len(self.thumbs):
                    f = self.thumbs[self.selected_idx].filename
                    subprocess.run(["awww", "img", os.path.join(WALL_DIR, f)])
                self.close()
            def on_key(self, w, e):
                if e.keyval == Gdk.KEY_Escape: self.close()
                elif e.keyval in (Gdk.KEY_Left, Gdk.KEY_h): self.select_by_index(self.selected_idx - 1)
                elif e.keyval in (Gdk.KEY_Right, Gdk.KEY_l): self.select_by_index(self.selected_idx + 1)
                elif e.keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter): self.apply_selected()
                return True

        if __name__ == "__main__":
            win = WallpaperPicker(); win.show_all(); Gtk.main()
      '')

    (pkgs.writers.writePython3Bin "layout-picker" {
        libraries = with pkgs.python3Packages; [pygobject3];
      } ''
        import gi
        gi.require_version("Gtk", "3.0")
        gi.require_version("Gdk", "3.0")
        import os, subprocess, sys
        from gi.repository import Gdk, Gtk, Pango

        BG_COLOR, ACCENT_COLOR, TEXT_COLOR, TEXT_DIM, CARD_BG, CARD_HOVER = "#1d2021", "#b8bb26", "#ebdbb2", "#a89984", "#282828", "#3c3836"
        LAYOUTS = [("T", "Tile"), ("S", "Scroller"), ("G", "Grid"), ("K", "Deck"), ("CT", "Center Tile"), ("RT", "Right Tile"), ("VS", "Vertical Scroller"), ("VT", "Vertical Tile"), ("VG", "Vertical Grid"), ("VK", "Vertical Deck"), ("TG", "TGMix")]

        def get_current_layout():
            try:
                res = subprocess.run(["mmsg", "-g"], capture_output=True, text=True, timeout=2)
                out = res.stdout.strip()
                if not out: return ""
                focused_mon = next((l.split()[0] for l in out.splitlines() if "selmon 1" in l), "")
                if not focused_mon: return ""
                return next((l.split()[-1] for l in out.splitlines() if l.startswith(f"{focused_mon} layout ")), "")
            except: return ""

        class LayoutRow(Gtk.EventBox):
            def __init__(self, code, name, is_current, window):
                super().__init__()
                self.code, self.name, self.window, self.is_selected, self.idx = code, name, window, False, 0
                self.set_size_request(320, 44)
                hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
                hbox.set_border_width(8)
                self.name_label = Gtk.Label(label=name)
                self.name_label.modify_font(Pango.FontDescription("JetBrains Mono 12"))
                hbox.pack_start(self.name_label, True, True, 0)
                if is_current:
                    curr = Gtk.Label(label="current")
                    curr.modify_font(Pango.FontDescription("JetBrains Mono Italic 9"))
                    hbox.pack_end(curr, False, False, 0)
                self.add(hbox); self._update_style()
                self.connect("button-press-event", self.on_click)
                self.connect("enter-notify-event", self.on_enter)
                self.connect("leave-notify-event", self.on_leave)
                self.set_events(Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK)
            def _update_style(self):
                bg = ACCENT_COLOR if self.is_selected else CARD_BG
                self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(bg))
            def on_click(self, w, e):
                if e.button == 1: self.window.select_row(self); self.window.apply_selected()
                return True
            def on_enter(self, w, e):
                if not self.is_selected: self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(CARD_HOVER))
                return True
            def on_leave(self, w, e): self._update_style(); return True
            def set_selected(self, s): self.is_selected = s; self._update_style()

        class LayoutPicker(Gtk.Window):
            def __init__(self):
                super().__init__(title="Layout Picker")
                self.set_decorated(False); self.set_resizable(False); self.set_position(Gtk.WindowPosition.CENTER); self.set_keep_above(True); self.set_type_hint(Gdk.WindowTypeHint.UTILITY)
                self.rows, self.selected_idx = [], -1
                current_layout = get_current_layout()
                main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
                main.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(BG_COLOR))
                title_lbl = Gtk.Label(label="Layout")
                title_lbl.modify_font(Pango.FontDescription("JetBrains Mono Bold 14"))
                title_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
                main.pack_start(title_lbl, False, False, 10)
                hint_lbl = Gtk.Label(label="Up/Down to navigate · Enter to select · Escape to cancel")
                hint_lbl.modify_font(Pango.FontDescription("JetBrains Mono 9"))
                hint_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_DIM))
                main.pack_start(hint_lbl, False, False, 10)
                scrolled = Gtk.ScrolledWindow()
                list_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
                for idx, (code, name) in enumerate(LAYOUTS):
                    row = LayoutRow(code, name, code == current_layout, self)
                    row.idx = idx; list_box.pack_start(row, False, False, 0); self.rows.append(row)
                scrolled.add(list_box); main.pack_start(scrolled, True, True, 0); self.add(main)
                self.connect("key-press-event", self.on_key); self.connect("destroy", Gtk.main_quit); self.show_all()
                self.select_by_index(next((i for i, r in enumerate(self.rows) if r.code == current_layout), 0))
            def select_by_index(self, idx):
                if not self.rows: return
                idx = idx % len(self.rows)
                if 0 <= self.selected_idx < len(self.rows): self.rows[self.selected_idx].set_selected(False)
                self.selected_idx = idx; self.rows[idx].set_selected(True)
            def select_row(self, r): self.select_by_index(r.idx)
            def apply_selected(self):
                if 0 <= self.selected_idx < len(self.rows):
                    subprocess.run(["mmsg", "-s", "-l", self.rows[self.selected_idx].code])
                self.close()
            def on_key(self, w, e):
                if e.keyval == Gdk.KEY_Escape: self.close()
                elif e.keyval in (Gdk.KEY_Up, Gdk.KEY_k): self.select_by_index(self.selected_idx - 1)
                elif e.keyval in (Gdk.KEY_Down, Gdk.KEY_j): self.select_by_index(self.selected_idx + 1)
                elif e.keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter): self.apply_selected()
                return True

        if __name__ == "__main__":
            LayoutPicker(); Gtk.main()
      '')

    (pkgs.writeShellScriptBin "mango-reload" ''
      mmsg -d reload_config
      switch-theme --apply
      ${pkgs.libnotify}/bin/notify-send "Mango Reloaded" "Configuration and theme refreshed"
    '')
  ];
}

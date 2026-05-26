{
  pkgs,
  config,
  ...
}: let
  # Helper to create a theme script block
  mkTheme = name: colors: ''
    case "$1" in
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
        CURSOR_THEME="Macintosh"
        CURSOR_SIZE="24"
        GTK_FONT="DepartureMono Nerd Font 11"
        MANGO_BORDER_FOCUSED="${colors.accent}"
        ;;
    esac
  '';

  # Catppuccin Mocha colors from Stylix
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
          # Picker for all themes
          selected=$(echo -e "catppuccin-mocha\ngruvbox\ncatppuccin-pink\ncatppuccin-purple\nmonochrome" | ${pkgs.wofi}/bin/wofi -d -p "Themes" -W 300 -H 350 -l center)
          [ -z "$selected" ] && exit 0
      fi

      # Theme definitions
      ${mkTheme "catppuccin-mocha" mocha}
      ${mkTheme "gruvbox" gruvbox}
      ${mkTheme "catppuccin-pink" pink}
      ${mkTheme "catppuccin-purple" purple}
      ${mkTheme "monochrome" monochrome}

      echo "$selected" > "$CURRENT_THEME_FILE"

      # Apply GTK settings
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "Macintosh"

      # Apply Wallpaper (use Stylix image)
      ${pkgs.awww}/bin/awww img "${config.stylix.image}"

      # Mango Colors
      MANGO_COLORS_FILE="$HOME/.config/mango/theme-colors.conf"
      cat > "$MANGO_COLORS_FILE" <<EOF
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

      # Reload Mango
      mmsg -d reload_config || true

      # Restart services
      pkill waybar || true
      waybar &
      pkill mako || true
      mako &

      ${pkgs.libnotify}/bin/notify-send "Theme Switched" "Now using: $selected"
    '')

    (pkgs.writeShellScriptBin "wall-select" ''
      ${pkgs.python3}/bin/python3 ${pkgs.writeText "wall-select.py" ''
        import gi
        gi.require_version("Gtk", "3.0")
        gi.require_version("Gdk", "3.0")
        gi.require_version("GdkPixbuf", "2.0")
        import hashlib, os, subprocess, sys
        from gi.repository import Gdk, GdkPixbuf, Gtk, Pango

        MANGO_DIR = os.path.expanduser("~/.config/mango")
        THEMES_DIR = os.path.join(MANGO_DIR, "themes")
        CURRENT_THEME_FILE = os.path.join(MANGO_DIR, ".theme")
        CACHE_DIR_BASE = os.path.expanduser("~/.cache/mango/wallpapers")
        DISPLAY_SIZE, SPACING, BORDER_WIDTH = 350, 16, 4
        BG_COLOR, ACCENT_COLOR, TEXT_COLOR, TEXT_DIM, CARD_BG, CARD_SELECTED, BORDER_COLOR = "#1d2021", "#b8bb26", "#ebdbb2", "#a89984", "#282828", "#3c3836", "#504945"
        IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".webp"}

        def _read_theme():
            if os.path.exists(CURRENT_THEME_FILE):
                with open(CURRENT_THEME_FILE, "r") as f: return f.read().strip()
            return "catppuccin-mocha"

        class WallpaperThumb(Gtk.EventBox):
            def __init__(self, filepath, filename, window):
                super().__init__()
                self.filepath, self.filename, self.window, self.is_selected, self.idx = filepath, filename, window, False, 0
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
                self.selected_idx, self.thumbs, self.current_theme = -1, [], _read_theme()
                self.wall_dir = os.path.expanduser("~/nixos/assets/wallpapers") # Default wallpaper dir
                if not os.path.exists(self.wall_dir): os.makedirs(self.wall_dir, exist_ok=True)
                main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
                main.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(BG_COLOR))
                for t, s in [("Select Wallpaper", 16), ("Enter to apply · Escape to cancel", 10)]:
                    lbl = Gtk.Label(label=t)
                    lbl.modify_font(Pango.FontDescription(f"JetBrains Mono {'Bold ' if s==16 else ''}{s}"))
                    lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR if s==16 else TEXT_DIM))
                    lbl.set_margin_bottom(20); main.pack_start(lbl, False, False, 0)
                scrolled = Gtk.ScrolledWindow()
                scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER)
                self.hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=SPACING)
                scrolled.add(self.hbox); main.pack_start(scrolled, True, True, 0); self.add(main)
                screen = Gdk.Screen.get_default()
                self.set_size_request(min(int(screen.get_width() * 0.95), 1800), 500)
                self.connect("key-press-event", self.on_key); self.connect("destroy", Gtk.main_quit); self._populate(); self.show_all()
                if self.thumbs: self.select_by_index(0)
            def _populate(self):
                walls = sorted([f for f in os.listdir(self.wall_dir) if os.path.splitext(f)[1].lower() in IMAGE_EXTS])
                for idx, f in enumerate(walls):
                    thumb = WallpaperThumb(os.path.join(self.wall_dir, f), f, self)
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
                    subprocess.run(["awww", "img", os.path.join(self.wall_dir, f)])
                    subprocess.Popen(["notify-send", "Wallpaper Changed", f, "-i", "preferences-desktop-wallpaper"])
                self.close()
            def on_key(self, w, e):
                if e.keyval == Gdk.KEY_Escape: self.close()
                elif e.keyval in (Gdk.KEY_Left, Gdk.KEY_h): self.select_by_index(self.selected_idx - 1)
                elif e.keyval in (Gdk.KEY_Right, Gdk.KEY_l): self.select_by_index(self.selected_idx + 1)
                elif e.keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter): self.apply_selected()
                return True

        if __name__ == "__main__":
            win = WallpaperPicker(); win.show_all(); Gtk.main()
      '''}
    '')

    (pkgs.writeShellScriptBin "layout-picker" ''
      ${pkgs.python3}/bin/python3 ${pkgs.writeText "layout-picker.py" ''
        import gi
        gi.require_version("Gtk", "3.0")
        gi.require_version("Gdk", "3.0")
        import os, subprocess, sys
        from gi.repository import Gdk, Gtk, Pango

        MANGO_DIR = os.path.expanduser("~/.config/mango")
        THEMES_DIR = os.path.join(MANGO_DIR, "themes")
        CURRENT_THEME_FILE = os.path.join(MANGO_DIR, ".theme")

        BG_COLOR, ACCENT_COLOR, TEXT_COLOR, TEXT_DIM, CARD_BG, CARD_HOVER, BORDER_COLOR = "#1d2021", "#b8bb26", "#ebdbb2", "#a89984", "#282828", "#3c3836", "#504945"

        LAYOUTS = [("T", "Tile"), ("S", "Scroller"), ("G", "Grid"), ("K", "Deck"), ("CT", "Center Tile"), ("RT", "Right Tile"), ("VS", "Vertical Scroller"), ("VT", "Vertical Tile"), ("VG", "Vertical Grid"), ("VK", "Vertical Deck"), ("TG", "TGMix")]

        def load_theme_colors():
            global BG_COLOR, ACCENT_COLOR, TEXT_COLOR, TEXT_DIM, CARD_BG, CARD_HOVER, BORDER_COLOR
            if not os.path.exists(CURRENT_THEME_FILE): return
            with open(CURRENT_THEME_FILE, "r") as f: theme = f.read().strip()
            # Theme logic here would need to know the colors from Nix, but for now we use defaults
            pass

        def get_current_layout():
            try:
                res = subprocess.run(["mmsg", "-g"], capture_output=True, text=True, timeout=2)
                out = res.stdout.strip()
                if not out: return ""
                focused_mon = next((l.split()[0] for l in out.splitlines() if "selmon 1" in l), "")
                if not focused_mon: return ""
                return next((l.split()[-1] for l in out.splitlines() if l.startswith(f"{focused_mon} layout ")), "")
            except: return ""

        def set_layout(code):
            try: subprocess.run(["mmsg", "-s", "-l", code], capture_output=True, timeout=2)
            except Exception as e: print(f"Failed to set layout: {e}")

        class LayoutRow(Gtk.EventBox):
            def __init__(self, code, name, is_current, window):
                super().__init__()
                self.code, self.name, self.window, self.is_selected, self.is_current, self.idx = code, name, window, False, is_current, 0
                self.set_size_request(320, 44)
                hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
                hbox.set_border_width(8)
                self.name_label = Gtk.Label(label=name)
                self.name_label.modify_font(Pango.FontDescription("JetBrains Mono 12"))
                self.name_label.set_halign(Gtk.Align.START)
                hbox.pack_start(self.name_label, True, True, 0)
                if is_current:
                    self.current_label = Gtk.Label(label="current")
                    self.current_label.modify_font(Pango.FontDescription("JetBrains Mono Italic 9"))
                    self.current_label.set_halign(Gtk.Align.END)
                    hbox.pack_end(self.current_label, False, False, 0)
                else: self.current_label = None
                self.add(hbox)
                self._update_style()
                self.connect("button-press-event", self.on_click)
                self.connect("enter-notify-event", self.on_enter)
                self.connect("leave-notify-event", self.on_leave)
                self.set_events(Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK)
            def _update_style(self):
                bg, fg = (ACCENT_COLOR, BG_COLOR) if self.is_selected else (CARD_BG, TEXT_COLOR)
                self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(bg))
                self.name_label.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(fg))
                if self.current_label: self.current_label.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(fg if self.is_selected else ACCENT_COLOR))
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
                for l, s in [(f"  Layout", 14), ("Up/Down to navigate  \u00b7  Enter to select  \u00b7  Escape to cancel", 9)]:
                    lbl = Gtk.Label(label=l)
                    lbl.modify_font(Pango.FontDescription(f"JetBrains Mono {'Bold ' if s==14 else ''}{s}"))
                    lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR if s==14 else TEXT_DIM))
                    lbl.set_margin_top(16 if s==14 else 0); lbl.set_margin_bottom(4 if s==14 else 12)
                    main.pack_start(lbl, False, False, 0)
                scrolled = Gtk.ScrolledWindow()
                scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
                scrolled.set_margin_left(16); scrolled.set_margin_right(16); scrolled.set_margin_bottom(16)
                list_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
                for idx, (code, name) in enumerate(LAYOUTS):
                    row = LayoutRow(code, name, code == current_layout, self)
                    row.idx = idx
                    list_box.pack_start(row, False, False, 0); self.rows.append(row)
                scrolled.add(list_box); main.pack_start(scrolled, True, True, 0); self.add(main)
                screen = Gdk.Screen.get_default()
                self.set_size_request(min(int(screen.get_width() * 0.3), 400), min(int(screen.get_height() * 0.7), 620))
                self.connect("key-press-event", self.on_key); self.connect("destroy", Gtk.main_quit); self.show_all()
                self.select_by_index(next((i for i, r in enumerate(self.rows) if r.is_current), 0))
            def select_by_index(self, idx):
                if not self.rows: return
                idx = idx % len(self.rows)
                if 0 <= self.selected_idx < len(self.rows): self.rows[self.selected_idx].set_selected(False)
                self.selected_idx = idx; self.rows[idx].set_selected(True)
                adj, alloc = self.get_child().get_children()[2].get_vadjustment(), self.rows[idx].get_allocation()
                if alloc.y < adj.get_value(): adj.set_value(alloc.y)
                elif alloc.y + alloc.height > adj.get_value() + adj.get_page_size(): adj.set_value(alloc.y + alloc.height - adj.get_page_size())
            def select_row(self, r): self.select_by_index(r.idx)
            def apply_selected(self):
                if 0 <= self.selected_idx < len(self.rows):
                    row = self.rows[self.selected_idx]
                    set_layout(row.code)
                    subprocess.Popen(["notify-send", "Layout Changed", row.name, "-i", "preferences-desktop-display"])
                self.close()
            def on_key(self, w, e):
                if e.keyval == Gdk.KEY_Escape: self.close()
                elif e.keyval in (Gdk.KEY_Up, Gdk.KEY_k): self.select_by_index(self.selected_idx - 1)
                elif e.keyval in (Gdk.KEY_Down, Gdk.KEY_j): self.select_by_index(self.selected_idx + 1)
                elif e.keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter): self.apply_selected()
                return True

        if __name__ == "__main__":
            style_provider = Gtk.CssProvider()
            style_provider.load_from_data(f"window {{ background-color: {BG_COLOR}; border-radius: 16px; }} button {{ background-color: transparent; border: none; border-radius: 8px; padding: 4px; outline: none; box-shadow: none; }} button:hover {{ background-color: {CARD_HOVER}; }} scrolledwindow {{ background-color: transparent; }} scrollbar {{ background-color: transparent; }} scrollbar slider {{ background-color: {BORDER_COLOR}; border-radius: 4px; min-height: 8px; }}".encode())
            Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
            LayoutPicker(); Gtk.main()
      '''}
    '')

    (pkgs.writeShellScriptBin "mango-reload" ''
      mmsg -d reload_config
      switch-theme --apply
      ${pkgs.libnotify}/bin/notify-send "Mango Reloaded" "Configuration and theme refreshed"
    '')
  ];
}

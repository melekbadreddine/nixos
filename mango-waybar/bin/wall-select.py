#!/usr/bin/env python3
"""
Wallpaper picker
SUPER+SHIFT+W
"""

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GdkPixbuf", "2.0")
import hashlib
import os
import subprocess
import sys

from gi.repository import Gdk, GdkPixbuf, Gtk, Pango

# ─── Configuration ───
MANGO_DIR = os.path.expanduser("~/.config/mango")
THEMES_DIR = os.path.join(MANGO_DIR, "themes")
CURRENT_THEME_FILE = os.path.join(MANGO_DIR, ".theme")
CACHE_DIR_BASE = os.path.expanduser("~/.cache/mango/wallpapers")

# Display settings
THUMBNAIL_SIZE = 800
DISPLAY_SIZE = 350
SPACING = 16
BORDER_WIDTH = 4

# Default colors (fallback)
BG_COLOR = "#1d2021"
ACCENT_COLOR = "#b8bb26"
TEXT_COLOR = "#ebdbb2"
TEXT_DIM = "#a89984"
CARD_BG = "#282828"
CARD_SELECTED = "#3c3836"
BORDER_COLOR = "#504945"

IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".webp"}


def load_theme_colors(theme_name):
    """Read theme colors from theme.conf"""
    global \
        BG_COLOR, \
        ACCENT_COLOR, \
        TEXT_COLOR, \
        TEXT_DIM, \
        CARD_BG, \
        CARD_SELECTED, \
        BORDER_COLOR
    theme_conf = os.path.join(THEMES_DIR, theme_name, "theme.conf")
    if not os.path.exists(theme_conf):
        return

    colors = {}
    with open(theme_conf, "r") as f:
        for line in f:
            line = line.strip()
            if "=" in line and not line.startswith("#"):
                key, val = line.split("=", 1)
                colors[key.strip()] = val.strip().strip('"').strip("'")

    BG_COLOR = colors.get("BG", BG_COLOR)
    ACCENT_COLOR = colors.get("ACCENT", ACCENT_COLOR)
    TEXT_COLOR = colors.get("FG", TEXT_COLOR)
    CARD_BG = colors.get("SURFACE", CARD_BG)
    CARD_SELECTED = colors.get("HOVER", CARD_SELECTED)
    BORDER_COLOR = colors.get("OUTLINE", BORDER_COLOR)


class WallpaperThumb(Gtk.EventBox):
    def __init__(self, filepath, filename, window):
        super().__init__()
        self.filepath = filepath
        self.filename = filename
        self.window = window
        self.is_selected = False
        self.idx = 0

        self.set_size_request(DISPLAY_SIZE, DISPLAY_SIZE)

        self.image = Gtk.Image()
        self.image.set_size_request(DISPLAY_SIZE, DISPLAY_SIZE)

        # Load thumbnail
        cache_dir = os.path.join(CACHE_DIR_BASE, window.current_theme)
        thumb_path = os.path.join(cache_dir, filename)

        try:
            if os.path.exists(thumb_path):
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                    thumb_path, DISPLAY_SIZE, DISPLAY_SIZE, False
                )
            else:
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                    filepath, DISPLAY_SIZE, DISPLAY_SIZE, False
                )
            self.image.set_from_pixbuf(pixbuf)
        except Exception as e:
            print(f"Error loading {filename}: {e}")
            self.image.set_from_icon_name("image-missing", Gtk.IconSize.DIALOG)
            self.image.set_pixel_size(DISPLAY_SIZE)

        self.add(self.image)
        self._update_style()

        # Events
        self.connect("button-press-event", self.on_click)
        self.connect("enter-notify-event", self.on_enter)
        self.connect("leave-notify-event", self.on_leave)
        self.set_events(
            Gdk.EventMask.BUTTON_PRESS_MASK
            | Gdk.EventMask.ENTER_NOTIFY_MASK
            | Gdk.EventMask.LEAVE_NOTIFY_MASK
        )

    def _update_style(self):
        if self.is_selected:
            self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(CARD_SELECTED))
            self.set_border_width(BORDER_WIDTH)
        else:
            self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(CARD_BG))
            self.set_border_width(0)

    def on_click(self, widget, event):
        if event.button == 1:
            self.window.select_by_thumb(self)
            self.window.apply_selected()
        return True

    def on_enter(self, widget, event):
        if not self.is_selected:
            self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(CARD_SELECTED))
        return True

    def on_leave(self, widget, event):
        self._update_style()
        return True

    def set_selected(self, selected):
        self.is_selected = selected
        self._update_style()


class WallpaperPicker(Gtk.Window):
    def __init__(self):
        super().__init__(title="Select Wallpaper")
        self.set_decorated(False)
        self.set_resizable(False)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_keep_above(True)
        self.set_type_hint(Gdk.WindowTypeHint.UTILITY)
        self.selected_idx = -1
        self.thumbs = []
        self.wall_dir = ""
        self.theme_dir = ""
        self.current_theme = ""

        # Read current theme
        self.current_theme = self._read_theme()
        if not self.current_theme or not os.path.exists(
            os.path.join(THEMES_DIR, self.current_theme)
        ):
            self._show_error("No current theme found")
            return

        # Load theme colors
        load_theme_colors(self.current_theme)

        self.theme_dir = os.path.join(THEMES_DIR, self.current_theme)
        self.wall_dir = os.path.join(self.theme_dir, "wallpapers")
        self.cache_dir = os.path.join(CACHE_DIR_BASE, self.current_theme)

        if not os.path.exists(self.wall_dir):
            self._show_error("Wallpapers directory not found")
            return

        # Generate thumbnails
        self._generate_thumbnails()

        # Main container
        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        self.main_box.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(BG_COLOR))
        self.main_box.set_border_width(0)

        # Title label
        title = Gtk.Label(label="Select Wallpaper")
        title.modify_font(Pango.FontDescription("JetBrains Mono Bold 16"))
        title.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
        title.set_margin_bottom(20)
        self.main_box.pack_start(title, False, False, 0)

        # Subtitle with hint
        hint = Gtk.Label(
            label="← → to navigate  ·  Enter to apply  ·  Escape to cancel"
        )
        hint.modify_font(Pango.FontDescription("JetBrains Mono 10"))
        hint.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_DIM))
        hint.set_margin_bottom(20)
        self.main_box.pack_start(hint, False, False, 0)

        # Scrollable horizontal area
        self.scrolled = Gtk.ScrolledWindow()
        self.scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER)
        self.scrolled.set_margin_bottom(10)

        # Horizontal box for thumbnails
        self.hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=SPACING)
        self.hbox.set_halign(Gtk.Align.CENTER)

        self.scrolled.add(self.hbox)
        self.main_box.pack_start(self.scrolled, True, True, 0)

        self.add(self.main_box)

        # Set window size (wide and shorter)
        screen = Gdk.Screen.get_default()
        width = min(int(screen.get_width() * 0.95), 1800)
        height = min(int(screen.get_height() * 0.55), 600)
        self.set_size_request(width, height)

        # Events
        self.connect("key-press-event", self.on_key_press)
        self.connect("destroy", Gtk.main_quit)

        # Populate
        self._populate()
        self.show_all()

        # Select first wallpaper by default
        if self.thumbs:
            self.select_by_index(0)

    def _read_theme(self):
        if os.path.exists(CURRENT_THEME_FILE):
            with open(CURRENT_THEME_FILE, "r") as f:
                return f.read().strip()
        return ""

    def _show_error(self, message):
        dialog = Gtk.MessageDialog(
            transient_for=self,
            flags=0,
            message_type=Gtk.MessageType.ERROR,
            buttons=Gtk.ButtonsType.OK,
            text=message,
        )
        dialog.run()
        dialog.destroy()
        Gtk.main_quit()
        sys.exit(1)

    def _generate_thumbnails(self):
        os.makedirs(self.cache_dir, exist_ok=True)

        wallpapers = [
            f
            for f in os.listdir(self.wall_dir)
            if os.path.splitext(f)[1].lower() in IMAGE_EXTS
        ]

        for filename in sorted(wallpapers):
            src = os.path.join(self.wall_dir, filename)
            cache_file = os.path.join(self.cache_dir, filename)
            md5_file = os.path.join(self.cache_dir, f".{filename}.md5")

            if os.path.exists(cache_file) and os.path.exists(md5_file):
                with open(src, "rb") as f:
                    current_md5 = hashlib.md5(f.read()).hexdigest()
                with open(md5_file, "r") as f:
                    cached_md5 = f.read().strip()
                if current_md5 == cached_md5:
                    continue

            try:
                subprocess.run(
                    [
                        "magick",
                        src,
                        "-resize",
                        f"{THUMBNAIL_SIZE}x{THUMBNAIL_SIZE}^",
                        "-gravity",
                        "center",
                        "-extent",
                        f"{THUMBNAIL_SIZE}x{THUMBNAIL_SIZE}",
                        cache_file,
                    ],
                    capture_output=True,
                    timeout=30,
                )
                with open(src, "rb") as f:
                    md5 = hashlib.md5(f.read()).hexdigest()
                with open(md5_file, "w") as f:
                    f.write(md5)
            except Exception as e:
                print(f"Failed to generate thumbnail for {filename}: {e}")

        # Clean orphaned cache files
        for cached in os.listdir(self.cache_dir):
            if cached.startswith("."):
                continue
            original = os.path.join(self.wall_dir, cached)
            if not os.path.exists(original):
                os.remove(os.path.join(self.cache_dir, cached))
                md5_file = os.path.join(self.cache_dir, f".{cached}.md5")
                if os.path.exists(md5_file):
                    os.remove(md5_file)

    def _populate(self):
        for child in self.hbox.get_children():
            self.hbox.remove(child)
        self.thumbs.clear()
        self.selected_idx = -1

        wallpapers = sorted(
            [
                f
                for f in os.listdir(self.wall_dir)
                if os.path.splitext(f)[1].lower() in IMAGE_EXTS
            ]
        )

        for idx, filename in enumerate(wallpapers):
            filepath = os.path.join(self.wall_dir, filename)
            thumb = WallpaperThumb(filepath, filename, self)
            thumb.idx = idx
            self.hbox.pack_start(thumb, False, False, 0)
            self.thumbs.append(thumb)
            thumb.show_all()

    def select_by_index(self, idx):
        if not self.thumbs:
            return
        if idx < 0:
            idx = len(self.thumbs) - 1
        elif idx >= len(self.thumbs):
            idx = 0

        if self.selected_idx >= 0 and self.selected_idx < len(self.thumbs):
            self.thumbs[self.selected_idx].set_selected(False)

        self.selected_idx = idx
        thumb = self.thumbs[idx]
        thumb.set_selected(True)

        # Scroll into view
        adj = self.scrolled.get_hadjustment()
        thumb_alloc = thumb.get_allocation()
        if thumb_alloc.x < adj.get_value():
            adj.set_value(thumb_alloc.x)
        elif thumb_alloc.x + thumb_alloc.width > adj.get_value() + adj.get_page_size():
            adj.set_value(thumb_alloc.x + thumb_alloc.width - adj.get_page_size())

    def select_by_thumb(self, thumb):
        self.select_by_index(thumb.idx)

    def apply_selected(self):
        if self.selected_idx < 0 or self.selected_idx >= len(self.thumbs):
            return

        filename = self.thumbs[self.selected_idx].filename

        # Update theme.conf
        theme_conf = os.path.join(self.theme_dir, "theme.conf")
        if os.path.exists(theme_conf):
            with open(theme_conf, "r") as f:
                lines = f.readlines()
            with open(theme_conf, "w") as f:
                for line in lines:
                    if line.startswith("WALLPAPER_DEFAULT="):
                        f.write(f'WALLPAPER_DEFAULT="{filename}"\n')
                    else:
                        f.write(line)

        # Set wallpaper using awww
        try:
            subprocess.run(["pgrep", "-x", "awww-daemon"], capture_output=True)
            wallpaper_path = os.path.join(self.wall_dir, filename)
            subprocess.run(["awww", "img", wallpaper_path])

            subprocess.Popen(
                [
                    "notify-send",
                    "Wallpaper Changed",
                    filename,
                    "-i",
                    "preferences-desktop-wallpaper",
                ]
            )
        except Exception as e:
            print(f"Failed to set wallpaper: {e}")

        self.close()

    def on_key_press(self, widget, event):
        key = event.keyval

        if key == Gdk.KEY_Escape:
            self.close()
        elif key in (Gdk.KEY_Left, Gdk.KEY_h):
            self.select_by_index(self.selected_idx - 1)
        elif key in (Gdk.KEY_Right, Gdk.KEY_l):
            self.select_by_index(self.selected_idx + 1)
        elif key in (Gdk.KEY_Return, Gdk.KEY_KP_Enter):
            self.apply_selected()
        return True


if __name__ == "__main__":
    # Apply CSS
    css = f"""
    window {{
        background-color: {BG_COLOR};
        border-radius: 16px;
    }}

    scrolledwindow {{
        background-color: transparent;
    }}

    scrollbar {{
        background-color: transparent;
    }}

    scrollbar slider {{
        background-color: {BORDER_COLOR};
        border-radius: 4px;
        min-height: 8px;
    }}
    """
    style_provider = Gtk.CssProvider()
    style_provider.load_from_data(css.encode())
    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default(),
        style_provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
    )

    window = WallpaperPicker()
    window.show_all()
    Gtk.main()

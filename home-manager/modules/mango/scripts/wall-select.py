import gi
import os
import subprocess

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GdkPixbuf", "2.0")

# Noqa for E402
from gi.repository import Gdk, GdkPixbuf, Gtk, Pango  # noqa: E402

WALL_DIR = os.path.expanduser("~/nixos/assets/wallpapers")
DISPLAY_SIZE, SPACING, BORDER_WIDTH = 350, 16, 4
BG_COLOR = "#1d2021"
TEXT_COLOR = "#ebdbb2"
TEXT_DIM = "#a89984"
CARD_BG = "#282828"
CARD_SELECTED = "#3c3836"


class WallpaperThumb(Gtk.EventBox):
    def __init__(self, filepath, filename, window):
        super().__init__()
        self.filepath = filepath
        self.filename = filename
        self.window = window
        self.is_selected = False
        self.set_size_request(DISPLAY_SIZE, DISPLAY_SIZE)
        self.image = Gtk.Image()
        self.image.set_size_request(DISPLAY_SIZE, DISPLAY_SIZE)
        try:
            pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                filepath, DISPLAY_SIZE, DISPLAY_SIZE, False
            )
            self.image.set_from_pixbuf(pixbuf)
        except Exception:
            self.image.set_from_icon_name("image-missing", Gtk.IconSize.DIALOG)
        self.add(self.image)
        self._update_style()
        self.connect("button-press-event", self.on_click)
        self.set_events(Gdk.EventMask.BUTTON_PRESS_MASK)

    def _update_style(self):
        bg = CARD_SELECTED if self.is_selected else CARD_BG
        self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(bg))
        self.set_border_width(BORDER_WIDTH if self.is_selected else 0)

    def on_click(self, widget, event):
        if event.button == 1:
            self.window.select_by_thumb(self)
            self.window.apply_selected()
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
        main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        main.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(BG_COLOR))

        title_lbl = Gtk.Label(label="Select Wallpaper")
        title_lbl.modify_font(Pango.FontDescription("JetBrains Mono Bold 16"))
        title_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
        main.pack_start(title_lbl, False, False, 10)

        msg = "Arrows to navigate · Enter to apply · Escape to cancel"
        hint_lbl = Gtk.Label(label=msg)
        hint_lbl.modify_font(Pango.FontDescription("JetBrains Mono 10"))
        hint_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_DIM))
        main.pack_start(hint_lbl, False, False, 10)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER)
        self.hbox = Gtk.Box(
            orientation=Gtk.Orientation.HORIZONTAL,
            spacing=SPACING
        )
        scrolled.add(self.hbox)
        main.pack_start(scrolled, True, True, 0)
        self.add(main)

        screen = Gdk.Screen.get_default()
        width = min(int(screen.get_width() * 0.95), 1800)
        self.set_size_request(width, 500)
        self.connect("key-press-event", self.on_key)
        self.connect("destroy", Gtk.main_quit)
        self._populate()
        self.show_all()
        if self.thumbs:
            self.select_by_index(0)

    def _populate(self):
        if not os.path.exists(WALL_DIR):
            return
        exts = (".jpg", ".jpeg", ".png", ".webp")
        walls = sorted([
            f for f in os.listdir(WALL_DIR)
            if f.lower().endswith(exts)
        ])
        for idx, f in enumerate(walls):
            thumb = WallpaperThumb(os.path.join(WALL_DIR, f), f, self)
            thumb.idx = idx
            self.hbox.pack_start(thumb, False, False, 0)
            self.thumbs.append(thumb)

    def select_by_index(self, idx):
        if not self.thumbs:
            return
        idx = idx % len(self.thumbs)
        if 0 <= self.selected_idx < len(self.thumbs):
            self.thumbs[self.selected_idx].set_selected(False)
        self.selected_idx = idx
        self.thumbs[idx].set_selected(True)

    def select_by_thumb(self, thumb):
        self.select_by_index(thumb.idx)

    def apply_selected(self):
        if 0 <= self.selected_idx < len(self.thumbs):
            f = self.thumbs[self.selected_idx].filename
            subprocess.run(["awww", "img", os.path.join(WALL_DIR, f)])
        self.close()

    def on_key(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.close()
        elif event.keyval in (Gdk.KEY_Left, Gdk.KEY_h):
            self.select_by_index(self.selected_idx - 1)
        elif event.keyval in (Gdk.KEY_Right, Gdk.KEY_l):
            self.select_by_index(self.selected_idx + 1)
        elif event.keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter):
            self.apply_selected()
        return True


if __name__ == "__main__":
    win = WallpaperPicker()
    win.show_all()
    Gtk.main()

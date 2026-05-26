#!/usr/bin/env python3
"""
Mango Layout Picker
CTRL+SHIFT+SPACE
"""

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
import os
import subprocess
import sys

from gi.repository import Gdk, Gtk, Pango

MANGO_DIR = os.path.expanduser("~/.config/mango")
THEMES_DIR = os.path.join(MANGO_DIR, "themes")
CURRENT_THEME_FILE = os.path.join(MANGO_DIR, ".theme")

# Default colors
BG_COLOR = "#1d2021"
ACCENT_COLOR = "#b8bb26"
TEXT_COLOR = "#ebdbb2"
TEXT_DIM = "#a89984"
CARD_BG = "#282828"
CARD_HOVER = "#3c3836"
BORDER_COLOR = "#504945"

# Layout definitions: (code, display_name)
LAYOUTS = [
    ("T",  "Tile"),
    ("S",  "Scroller"),
    ("G",  "Grid"),
    # ("M",  "Monocle"),
    ("K",  "Deck"),
    ("CT", "Center Tile"),
    ("RT", "Right Tile"),
    ("VS", "Vertical Scroller"),
    ("VT", "Vertical Tile"),
    ("VG", "Vertical Grid"),
    ("VK", "Vertical Deck"),
    ("TG", "TGMix"),
]


def load_theme_colors():
    global \
        BG_COLOR, \
        ACCENT_COLOR, \
        TEXT_COLOR, \
        TEXT_DIM, \
        CARD_BG, \
        CARD_HOVER, \
        BORDER_COLOR
    if not os.path.exists(CURRENT_THEME_FILE):
        return
    theme = ""
    with open(CURRENT_THEME_FILE, "r") as f:
        theme = f.read().strip()
    conf = os.path.join(THEMES_DIR, theme, "theme.conf")
    if not os.path.exists(conf):
        return
    colors = {}
    with open(conf, "r") as f:
        for line in f:
            line = line.strip()
            if "=" in line and not line.startswith("#"):
                key, val = line.split("=", 1)
                colors[key.strip()] = val.strip().strip('"').strip("'")
    BG_COLOR = colors.get("BG", BG_COLOR)
    ACCENT_COLOR = colors.get("ACCENT", ACCENT_COLOR)
    TEXT_COLOR = colors.get("FG", TEXT_COLOR)
    CARD_BG = colors.get("SURFACE", CARD_BG)
    CARD_HOVER = colors.get("HOVER", CARD_HOVER)
    BORDER_COLOR = colors.get("OUTLINE", BORDER_COLOR)


def get_current_layout():
    try:
        result = subprocess.run(
            ["mmsg", "-g"], capture_output=True, text=True, timeout=2
        )
        output = result.stdout.strip()
        if not output:
            return ""
        # Find focused monitor (selmon 1)
        focused_mon = ""
        for line in output.splitlines():
            if "selmon 1" in line:
                focused_mon = line.split()[0]
                break
        if not focused_mon:
            return ""
        # Get layout for focused monitor
        for line in output.splitlines():
            if line.startswith(f"{focused_mon} layout "):
                return line.split()[-1]
    except Exception:
        pass
    return ""


def set_layout(code):
    try:
        subprocess.run(
            ["mmsg", "-s", "-l", code], capture_output=True, timeout=2
        )
    except Exception as e:
        print(f"Failed to set layout: {e}")


class LayoutRow(Gtk.EventBox):
    def __init__(self, code, name, is_current, window):
        super().__init__()
        self.code = code
        self.name = name
        self.window = window
        self.is_selected = False
        self.is_current = is_current
        self.idx = 0

        self.set_size_request(320, 44)

        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        hbox.set_border_width(8)

        # Layout name
        self.name_label = Gtk.Label(label=name)
        self.name_label.modify_font(Pango.FontDescription("JetBrains Mono 12"))
        self.name_label.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
        self.name_label.set_halign(Gtk.Align.START)
        hbox.pack_start(self.name_label, True, True, 0)

        # Current indicator
        if is_current:
            self.current_label = Gtk.Label(label="current")
            self.current_label.modify_font(
                Pango.FontDescription("JetBrains Mono Italic 9")
            )
            self.current_label.modify_fg(
                Gtk.StateType.NORMAL, Gdk.color_parse(ACCENT_COLOR)
            )
            self.current_label.set_halign(Gtk.Align.END)
            hbox.pack_end(self.current_label, False, False, 0)
        else:
            self.current_label = None

        self.add(hbox)
        self._update_style()

        self.connect("button-press-event", self.on_click)
        self.connect("enter-notify-event", self.on_enter)
        self.connect("leave-notify-event", self.on_leave)
        self.set_events(
            Gdk.EventMask.BUTTON_PRESS_MASK
            | Gdk.EventMask.ENTER_NOTIFY_MASK
            | Gdk.EventMask.LEAVE_NOTIFY_MASK
        )

    def _update_text_color(self, color):
        self.name_label.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(color))
        if self.current_label:
            self.current_label.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(color))

    def _update_style(self):
        if self.is_selected:
            self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(ACCENT_COLOR))
            self._update_text_color(BG_COLOR)
        else:
            self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(CARD_BG))
            self._update_text_color(TEXT_COLOR)

    def on_click(self, widget, event):
        if event.button == 1:
            self.window.select_row(self)
            self.window.apply_selected()
        return True

    def on_enter(self, widget, event):
        if not self.is_selected:
            self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(CARD_HOVER))
        return True

    def on_leave(self, widget, event):
        self._update_style()
        return True

    def set_selected(self, selected):
        self.is_selected = selected
        self._update_style()


class LayoutPicker(Gtk.Window):
    def __init__(self):
        super().__init__(title="Layout Picker")
        self.set_decorated(False)
        self.set_resizable(False)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_keep_above(True)
        self.set_type_hint(Gdk.WindowTypeHint.UTILITY)
        self.rows = []
        self.selected_idx = -1

        current_layout = get_current_layout()

        main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        main.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(BG_COLOR))
        main.set_border_width(0)

        # Title
        title = Gtk.Label(label="  Layout")
        title.modify_font(Pango.FontDescription("JetBrains Mono Bold 14"))
        title.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
        title.set_margin_top(16)
        title.set_margin_bottom(4)
        main.pack_start(title, False, False, 0)

        # Hint
        hint = Gtk.Label(
            label="Up/Down to navigate  \u00b7  Enter to select  \u00b7  Escape to cancel"
        )
        hint.modify_font(Pango.FontDescription("JetBrains Mono 9"))
        hint.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_DIM))
        hint.set_margin_bottom(12)
        main.pack_start(hint, False, False, 0)

        # Scrolled layout list
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled.set_margin_left(16)
        scrolled.set_margin_right(16)
        scrolled.set_margin_bottom(16)

        list_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        list_box.set_halign(Gtk.Align.CENTER)

        for idx, (code, name) in enumerate(LAYOUTS):
            is_current = code == current_layout
            row = LayoutRow(code, name, is_current, self)
            row.idx = idx
            list_box.pack_start(row, False, False, 0)
            self.rows.append(row)

        scrolled.add(list_box)
        main.pack_start(scrolled, True, True, 0)

        self.add(main)

        # Window size
        screen = Gdk.Screen.get_default()
        w = min(int(screen.get_width() * 0.3), 400)
        h = min(int(screen.get_height() * 0.7), 620)
        self.set_size_request(w, h)

        self.connect("key-press-event", self.on_key)
        self.connect("destroy", Gtk.main_quit)

        self.show_all()

        # Select current layout by default, or first if not found
        start_idx = 0
        for idx, row in enumerate(self.rows):
            if row.is_current:
                start_idx = idx
                break
        self.select_by_index(start_idx)

    def select_by_index(self, idx):
        if not self.rows:
            return
        if idx < 0:
            idx = len(self.rows) - 1
        elif idx >= len(self.rows):
            idx = 0

        if 0 <= self.selected_idx < len(self.rows):
            self.rows[self.selected_idx].set_selected(False)

        self.selected_idx = idx
        self.rows[idx].set_selected(True)

        # Scroll into view
        adj = self.get_child().get_children()[2].get_vadjustment()
        alloc = self.rows[idx].get_allocation()
        if alloc.y < adj.get_value():
            adj.set_value(alloc.y)
        elif alloc.y + alloc.height > adj.get_value() + adj.get_page_size():
            adj.set_value(alloc.y + alloc.height - adj.get_page_size())

    def select_row(self, row):
        self.select_by_index(row.idx)

    def apply_selected(self):
        if self.selected_idx < 0 or self.selected_idx >= len(self.rows):
            return

        row = self.rows[self.selected_idx]
        set_layout(row.code)

        subprocess.Popen(
            [
                "notify-send",
                "Layout Changed",
                row.name,
                "-i",
                "preferences-desktop-display",
            ]
        )
        self.close()

    def on_key(self, widget, event):
        key = event.keyval
        if key == Gdk.KEY_Escape:
            self.close()
        elif key in (Gdk.KEY_Up, Gdk.KEY_k):
            self.select_by_index(self.selected_idx - 1)
        elif key in (Gdk.KEY_Down, Gdk.KEY_j):
            self.select_by_index(self.selected_idx + 1)
        elif key in (Gdk.KEY_Return, Gdk.KEY_KP_Enter):
            self.apply_selected()
        return True


if __name__ == "__main__":
    load_theme_colors()
    css = f"""
    window {{
        background-color: {BG_COLOR};
        border-radius: 16px;
    }}

    button {{
        background-color: transparent;
        border: none;
        border-radius: 8px;
        padding: 4px;
        outline: none;
        box-shadow: none;
    }}

    button:hover {{
        background-color: {CARD_HOVER};
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
    provider = Gtk.CssProvider()
    provider.load_from_data(css.encode())
    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default(),
        provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
    )
    win = LayoutPicker()
    Gtk.main()

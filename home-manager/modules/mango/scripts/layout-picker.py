import gi
import subprocess

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
# Noqa for E402
from gi.repository import Gdk, Gtk, Pango  # noqa: E402

BG_COLOR = "#1d2021"
ACCENT_COLOR = "#b8bb26"
TEXT_COLOR = "#ebdbb2"
TEXT_DIM = "#a89984"
CARD_BG = "#282828"
CARD_HOVER = "#3c3836"
LAYOUTS = [
    ("T", "Tile"), ("S", "Scroller"), ("G", "Grid"), ("K", "Deck"),
    ("CT", "Center Tile"), ("RT", "Right Tile"), ("VS", "Vertical Scroller"),
    ("VT", "Vertical Tile"), ("VG", "Vertical Grid"), ("VK", "Vertical Deck"),
    ("TG", "TGMix")
]


def get_current_layout():
    try:
        res = subprocess.run(
            ["mmsg", "-g"], capture_output=True, text=True, timeout=2
        )
        out = res.stdout.strip()
        if not out:
            return ""
        focused_mon = next(
            (line.split()[0] for line in out.splitlines() if "selmon 1" in line),
            ""
        )
        if not focused_mon:
            return ""
        return next(
            (line.split()[-1] for line in out.splitlines()
             if line.startswith(f"{focused_mon} layout ")),
            ""
        )
    except Exception:
        return ""


class LayoutRow(Gtk.EventBox):
    def __init__(self, code, name, is_current, window):
        super().__init__()
        self.code = code
        self.name = name
        self.window = window
        self.is_selected = False
        self.idx = 0
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
        self.add(hbox)
        self._update_style()
        self.connect("button-press-event", self.on_click)
        self.connect("enter-notify-event", self.on_enter)
        self.connect("leave-notify-event", self.on_leave)
        mask = (
            Gdk.EventMask.BUTTON_PRESS_MASK |
            Gdk.EventMask.ENTER_NOTIFY_MASK |
            Gdk.EventMask.LEAVE_NOTIFY_MASK
        )
        self.set_events(mask)

    def _update_style(self):
        bg = ACCENT_COLOR if self.is_selected else CARD_BG
        self.modify_bg(Gtk.StateType.NORMAL, Gdk.color_parse(bg))

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

        title_lbl = Gtk.Label(label="Layout")
        title_lbl.modify_font(Pango.FontDescription("JetBrains Mono Bold 14"))
        title_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_COLOR))
        main.pack_start(title_lbl, False, False, 10)

        msg = "Up/Down to navigate · Enter to select · Escape to cancel"
        hint_lbl = Gtk.Label(label=msg)
        hint_lbl.modify_font(Pango.FontDescription("JetBrains Mono 9"))
        hint_lbl.modify_fg(Gtk.StateType.NORMAL, Gdk.color_parse(TEXT_DIM))
        main.pack_start(hint_lbl, False, False, 10)

        scrolled = Gtk.ScrolledWindow()
        list_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        for idx, (code, name) in enumerate(LAYOUTS):
            row = LayoutRow(code, name, code == current_layout, self)
            row.idx = idx
            list_box.pack_start(row, False, False, 0)
            self.rows.append(row)
        scrolled.add(list_box)
        main.pack_start(scrolled, True, True, 0)
        self.add(main)
        self.connect("key-press-event", self.on_key)
        self.connect("destroy", Gtk.main_quit)
        self.show_all()
        start_idx = 0
        for i, r in enumerate(self.rows):
            if r.code == current_layout:
                start_idx = i
                break
        self.select_by_index(start_idx)

    def select_by_index(self, idx):
        if not self.rows:
            return
        idx = idx % len(self.rows)
        if 0 <= self.selected_idx < len(self.rows):
            self.rows[self.selected_idx].set_selected(False)
        self.selected_idx = idx
        self.rows[idx].set_selected(True)

    def select_row(self, row):
        self.select_by_index(row.idx)

    def apply_selected(self):
        if 0 <= self.selected_idx < len(self.rows):
            code = self.rows[self.selected_idx].code
            subprocess.run(["mmsg", "-s", "-l", code])
        self.close()

    def on_key(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.close()
        elif event.keyval in (Gdk.KEY_Up, Gdk.KEY_k):
            self.select_by_index(self.selected_idx - 1)
        elif event.keyval in (Gdk.KEY_Down, Gdk.KEY_j):
            self.select_by_index(self.selected_idx + 1)
        elif event.keyval in (Gdk.KEY_Return, Gdk.KEY_KP_Enter):
            self.apply_selected()
        return True


if __name__ == "__main__":
    LayoutPicker()
    Gtk.main()

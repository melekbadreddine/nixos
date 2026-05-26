# Mango WM Dotfiles

A portable, themeable Wayland window manager setup built around [Mango WM](https://github.com/DreamMaoMao/mango). Includes a fully themed waybar, wofi launcher, mako notifications, and a comprehensive theme switching system.

## Quick Start

```bash
# Clone the repository
https://codeberg.org/theblackdon/mango-waybar.git ~/dotfiles/mango
cd ~/dotfiles/mango

# Run the installer
bash install.sh
```

The installer will guide you through:
1. Choosing a repository location
2. Selecting install mode (Full WM or Waybar-only)
3. Choosing symlink or copy
4. Installing dependencies automatically
5. Backing up existing configs
6. Generating initial theme configs

## Prerequisites

### Required Packages

| Package | Purpose |
|---------|---------|
| `waybar` | Status bar |
| `kitty` | Terminal emulator |
| `wofi` | Application launcher |
| `mako` | Notification daemon |
| `grim` + `slurp` | Screenshots |
| `wl-clipboard` | Clipboard support |
| `ImageMagick` | Image processing (logo theming, thumbnails) |
| `jq` | JSON processing |
| `libnotify` | Desktop notifications |
| `python3-gobject` | GTK Python bindings |
| `python3-evdev` | Input device access (DualSense script) |
| `gtk3` / `gtk4` | GTK libraries |
| `qt5-qtbase` / `qt6-qtbase` | Qt libraries |

### Optional Applications (launched via keybinds)

`steam`, `obs`, `zed`, `helix` (hx), `yazi`, `discord`, `telegram`, `qutebrowser`, `kdenlive`, `nemo`, `crystal-dock`, `awww` (wallpaper daemon), `wlogout`, `fzf`, `fastfetch`, `htop`

### GTK Themes

| Theme | Source |
|-------|--------|
| Graphite-Dark | [GitHub](https://github.com/vinceliuice/graphite-gtk-theme) or repo package `graphite-gtk-theme` |
| Catppuccin Mocha | [GitHub](https://github.com/catppuccin/gtk) or repo package `catppuccin-gtk-theme-mocha` |
| Material-Black | [GitHub](https://github.com/Elbullazul/Material-Black) |

### Icon Themes

| Theme | Source |
|-------|--------|
| Tela | [GitHub](https://github.com/vinceliuice/Tela-icon-theme) or repo package `tela-icon-theme` |
| Gruvbox-Plus | [GitHub](https://github.com/SylEleuth/gruvbox-plus-icon-pack) |

### Cursor Theme

| Theme | Source |
|-------|--------|
| Bibata Modern Ice | [GitHub](https://github.com/ful1e5/Bibata_Cursor) or repo package `bibata-cursor-theme` |

## Installation

### Automated Install (Recommended)

```bash
bash install.sh
```

The installer handles everything: dependency installation, config placement, symlinks, and initial theme generation.

### Manual Install

```bash
# 1. Clone to your preferred location
git clone https://github.com/YOUR_USERNAME/mango.git ~/dotfiles/mango

# 2. Create config directory
mkdir -p ~/.config/mango

# 3. Symlink individual directories
ln -sf ~/dotfiles/mango/bin ~/.config/mango/bin
ln -sf ~/dotfiles/mango/templates ~/.config/mango/templates
ln -sf ~/dotfiles/mango/themes ~/.config/mango/themes
ln -sf ~/dotfiles/mango/bars ~/.config/mango/bars
ln -sf ~/dotfiles/mango/bind.conf ~/.config/mango/bind.conf
ln -sf ~/dotfiles/mango/config.conf ~/.config/mango/config.conf
ln -sf ~/dotfiles/mango/env.conf ~/.config/mango/env.conf
ln -sf ~/dotfiles/mango/autostart.sh ~/.config/mango/autostart.sh
ln -sf ~/dotfiles/mango/.theme ~/.config/mango/.theme

# 4. Copy hardware-neutral defaults
cp ~/dotfiles/mango/monitor.conf.default ~/.config/mango/monitor.conf
cp ~/dotfiles/mango/tag.conf.default ~/.config/mango/tag.conf
cp ~/dotfiles/mango/rule.conf.default ~/.config/mango/rule.conf

# 5. Symlink waybar and wofi
ln -sf ~/dotfiles/mango/waybar ~/.config/waybar
ln -sf ~/dotfiles/mango/wofi ~/.config/wofi

# 6. Make scripts executable
chmod +x ~/.config/mango/bin/*.sh ~/.config/mango/bin/*.py
chmod +x ~/.config/waybar/scripts/*.sh ~/.config/waybar/scripts/*.py

# 7. Apply initial theme
~/.config/mango/bin/switch-theme.sh --apply
```

## Keybind Reference

### System

| Keybind | Action |
|---------|--------|
| `SUPER+ALT+R` | Reload config |
| `SUPER+ALT+L` | Lock screen |
| `SUPER+M` | Quit Mango |
| `SUPER+Q` | Kill focused window |
| `SUPER+SHIFT+Q` | Logout menu (wlogout) |
| `SUPER+SHIFT+T` | Theme picker |
| `SUPER+SHIFT+W` | Wallpaper picker |

### Applications

| Keybind | Action |
|---------|--------|
| `SUPER+Return` | Terminal (kitty) |
| `SUPER+CTRL+Return` | Terminal (floating) |
| `SUPER+Space` | App launcher (wofi) |
| `SUPER+S` | Steam |
| `SUPER+O` | OBS |
| `SUPER+Z` | Zed editor |
| `SUPER+E` | Helix (in kitty) |
| `SUPER+Y` | Yazi (floating) |
| `SUPER+D` | Discord |
| `SUPER+G` | Telegram |
| `SUPER+B` | Helium browser |
| `SUPER+ALT+B` | Qutebrowser |
| `SUPER+K` | Kdenlive |
| `SUPER+F` | Nemo file manager |

### Window Focus

| Keybind | Action |
|---------|--------|
| `SUPER+←/→/↑/↓` | Focus direction |
| `SUPER+SHIFT+←/→/↑/↓` | Move window direction |

### Workspaces

| Keybind | Action |
|---------|--------|
| `SUPER+1-9` | View workspace 1-9 |
| `SUPER+SHIFT+1-9` | Move window to workspace |
| `SUPER+CTRL+↑/↓` | Switch workspace left/right |
| `SUPER+CTRL+ALT+↑/↓` | Move window to workspace |

### Window States

| Keybind | Action |
|---------|--------|
| `SUPER+W` | Toggle floating |
| `ALT+Tab` | Toggle overview |
| `SUPER+Tab` | Focus stack next |
| `SUPER+X` | Logout menu |
| `ALT+F` | Toggle fullscreen |
| `ALT+SHIFT+F` | Toggle fake fullscreen |
| `ALT+A` | Toggle maximize |
| `SUPER+I` | Minimize |
| `SUPER+SHIFT+I` | Restore minimized |
| `ALT+Z` | Toggle scratchpad |

### Screenshot

| Keybind | Action |
|---------|--------|
| `SUPER+SHIFT+S` | Area screenshot (grim+slurp) |

### Gaps & Layout

| Keybind | Action |
|---------|--------|
| `CTRL+Space` | Switch layout |
| `ALT+SHIFT+X/Z` | Increase/decrease gaps |
| `ALT+SHIFT+R` | Toggle gaps |

### Mouse

| Keybind | Action |
|---------|--------|
| `SUPER+LeftBtn` | Move window |
| `SUPER+RightBtn` | Resize window |

## Theme System

### How It Works

Themes are defined in `themes/<name>/theme.conf` and applied via `switch-theme.sh`. Each theme controls:

- **Colors**: Background, foreground, accent, terminal colors, etc.
- **GTK Theme**: The GTK theme name to apply
- **Icon Theme**: The icon pack to use
- **Cursor Theme**: Mouse cursor appearance
- **Wallpaper**: Default wallpaper for the theme
- **Waybar Override**: Optional theme-specific waybar CSS
- **Kitty Override**: Optional theme-specific terminal colors

### Switching Themes

```bash
# Interactive picker (SUPER+SHIFT+T)
~/.config/mango/bin/switch-theme.sh

# Apply current theme silently (used in autostart)
~/.config/mango/bin/switch-theme.sh --apply
```

### Creating a Custom Theme

1. Copy an existing theme as a starting point:
   ```bash
   cp -r ~/.config/mango/themes/gruvbox ~/.config/mango/themes/my-theme
   ```

2. Edit `theme.conf` with your colors:
   ```bash
   THEME_NAME="My Theme"
   BG="#1a1a2e"
   FG="#e0e0e0"
   ACCENT="#e94560"
   # ... (see existing themes for all variables)
   ```

3. Add a preview image (optional):
   ```bash
   # Place preview.png or preview.jpg in the theme directory
   ```

4. Switch to your theme:
   ```bash
   ~/.config/mango/bin/switch-theme.sh
   ```

### Theme Variables

| Variable | Example | Purpose |
|----------|---------|---------|
| `THEME_NAME` | `"My Theme"` | Display name |
| `BG` / `FG` | `"#1a1a2e"` / `"#e0e0e0"` | Background / foreground |
| `PRIMARY` / `SECONDARY` / `TERTIARY` | `"#e94560"` | Accent colors |
| `ACCENT` | `"#e94560"` | Main accent (used for logo, focused workspace) |
| `ERROR` / `WARNING` / `SUCCESS` | `"#ff4444"` | Status colors |
| `SURFACE` / `OUTLINE` / `SHADOW` | `"#16213e"` | UI surface colors |
| `BLACK`–`WHITEB` | `"#1a1a2e"`–`"#cccccc"` | 16 terminal colors |
| `GTK_THEME` | `"Graphite-Dark"` | GTK theme name |
| `ICON_THEME` | `"Tela-pink-dark"` | Icon theme name |
| `CURSOR_THEME` | `"Bibata-Modern-Ice"` | Cursor theme |
| `BAR_NAME` | `"full"` | Which bar config to use |
| `WALLPAPER_DEFAULT` | `"wallpaper.jpg"` | Default wallpaper filename |

## Waybar-Only Usage

You can use just the waybar configuration without Mango WM. Select option **2** during installation.

### What's Included

- Themed waybar with Fedora logo
- Dynamic multi-monitor config generation
- Theme switching system (waybar, wofi, mako, GTK, kitty, Qt)
- Screenshot tool (grim+slurp)
- Wallpaper picker (GTK grid selector)

### Required Keybinds for Your WM

Add these to your window manager's config:

```
# Theme picker
SUPER+SHIFT+T  →  ~/.config/mango/bin/switch-theme.sh

# Wallpaper picker
SUPER+SHIFT+W  →  ~/.config/mango/bin/wall-select.sh

# Screenshot
SUPER+SHIFT+S  →  ~/.config/mango/bin/screenshot.sh

# App launcher
SUPER+Space    →  wofi -S drun -I -W 600 -H 400 -l center -p "Search apps..." -s ~/.config/mango/wofi/style.css
```

### Starting Waybar

Add to your WM's autostart:
```bash
~/.config/mango/bin/switch-theme.sh --apply &
```

## Hardware Configuration

The installer provides hardware-neutral defaults. Customize these files for your setup:

### Monitor Configuration (`monitor.conf`)

```bash
# Find your monitor names
wlr-randr

# Edit monitor.conf
nano ~/.config/mango/monitor.conf
```

Format:
```
monitorrule=name:^DP-1$,width:3440,height:1440,refresh:180,x:0,y:0,scale:1,rr:0
```

- `rr`: rotation (0=normal, 1=90° CW, 2=180°, 3=270° CW)
- Leave empty for auto-detection

### Tag Layouts (`tag.conf`)

```bash
nano ~/.config/mango/tag.conf
```

Format:
```
tagrule=id:1,monitor_name:^DP-1$,layout_name:scroller
```

Available layouts: `tile`, `scroller`, `grid`, `deck`, `monocle`, `center_tile`, `vertical_tile`, `right_tile`, `vertical_scroller`, `vertical_grid`, `vertical_deck`, `tgmix`

### Window Rules (`rule.conf`)

```bash
nano ~/.config/mango/rule.conf
```

Find app IDs with `wayland-info` or check WM logs.

## Directory Structure

```
mango/
├── install.sh                 # Portable installer
├── README.md                  # This file
├── .theme                     # Current theme name
├── .recording_mode            # Recording mode state
├── bind.conf                  # Key bindings
├── config.conf                # Main WM config
├── env.conf                   # Environment variables
├── monitor.conf.default       # Generic monitor template
├── tag.conf.default           # Generic tag layout template
├── rule.conf.default          # Generic window rules
├── autostart.sh               # Startup script
├── theme-colors.conf          # Auto-generated WM colors
│
├── bin/                       # Scripts
│   ├── switch-theme.sh        # Theme picker/applier
│   ├── generate-waybar-config.py  # Dynamic waybar config
│   ├── wall-select.py         # GTK wallpaper picker
│   ├── screenshot.sh          # grim+slurp screenshot
│   └── ...
│
├── templates/                 # Config templates
│   ├── wofi-style.css.template
│   ├── mako-config.template
│   ├── kitty-theme.conf.template
│   └── ...
│
├── themes/                    # Theme definitions
│   ├── gruvbox/
│   ├── catppuccin-pink/
│   ├── catppuccin-purple/
│   └── monochrome/
│       ├── theme.conf
│       ├── kitty/theme.conf
│       ├── waybar/style.css
│       └── wallpapers/
│
├── bars/                      # Waybar bar definitions
│   └── full/
│       ├── config.jsonc
│       └── style.css.template
│
├── waybar/                    # Waybar configs & scripts
│   ├── config.jsonc
│   └── scripts/
│       ├── fedora-logo-themed.sh
│       ├── notifications.sh
│       └── logout-menu.py
│
└── wofi/                      # Wofi launcher configs
    ├── config
    └── style.css
```

## Troubleshooting

### Waybar not showing themed logo

The logo script reads the current theme from `~/.config/mango/.theme`. Make sure:
1. The theme name in `.theme` matches a directory in `themes/`
2. The theme's `theme.conf` has an `ACCENT` color defined
3. Restart waybar: `killall waybar && waybar &`

### GTK theme not applying

1. Check that the GTK theme is installed: `ls ~/.local/share/themes/`
2. Verify `gtk-theme-name` in `~/.config/gtk-3.0/settings.ini`
3. Run: `gsettings set org.gnome.desktop.interface gtk-theme "YourTheme"`
4. Restart GTK apps

### Icons not updating

```bash
# Update icon cache
gtk-update-icon-cache -f -t ~/.local/share/icons/YourIconTheme
gtk-update-icon-cache -f -t /usr/share/icons/YourIconTheme
```

### Theme switch fails

```bash
# Run with debug output
bash -x ~/.config/mango/bin/switch-theme.sh --apply
```

### Waybar config not generating

```bash
# Test the generator manually
python3 ~/.config/mango/bin/generate-waybar-config.py
```

### Monitor not detected

```bash
# List connected outputs
wlr-randr
# or
ls /sys/class/drm/card*-*/status
```

## License

This dotfiles repository is provided as-is. Mango WM is developed by [DreamMaoMao](https://github.com/DreamMaoMao/mango).

## Credits

- [Mango WM](https://github.com/DreamMaoMao/mango) — Window manager
- [waybar](https://github.com/Alexays/Waybar) — Status bar
- [wofi](https://hg.sr.ht/~scoopta/wofi) — Application launcher
- [mako](https://github.com/emersion/mako) — Notification daemon
- [kitty](https://github.com/kovidgoyal/kitty) — Terminal emulator
- [@jtekk](https://github.com/jtekk) — Inspiration & contributions
- [gh0stzk dotfiles](https://github.com/gh0stzk/dotfiles) — Inspiration & reference

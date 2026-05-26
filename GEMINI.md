## PHASE 0 — Read & Understand the Codebase First

You are an expert NixOS engineer. Before making **any** changes, do the following:

1. **Explore the NixOS config repo** (root of the current working directory, i.e. `~/nixos`). Read every file listed below in full. Understand the architecture — hosts, profiles, modules/core, modules/drivers, modules/desktops, home-manager modules, the flake inputs, and the justfile.

   Key files to read (use `cat` or `read_file`):
   - `flake.nix`
   - `modules/core/variables.nix`
   - `modules/core/stylix.nix`
   - `modules/core/system.nix`
   - `modules/core/virtualisation.nix`
   - `modules/core/services.nix`
   - `modules/desktops/cosmic.nix`
   - `modules/desktops/default.nix`
   - `home-manager/home.nix`
   - `home-manager/modules/default.nix`
   - `home-manager/modules/stylix.nix`
   - `home-manager/modules/misc/mime.nix`
   - `home-manager/modules/programs/ghostty.nix`
   - `home-manager/modules/programs/warp.nix`
   - `home-manager/modules/programs/helium.nix`
   - `home-manager/modules/programs/zen.nix`
   - `home-manager/modules/cli/git.nix`
   - `home-manager/modules/shell/fish.nix`
   - `home-manager/modules/shell/bash.nix`
   - `home-manager/modules/cli/starship.nix`
   - `home-manager/modules/cli/fastfetch.nix`
   - `home-manager/modules/cli/zellij.nix`
   - `home-manager/modules/cli/yazi.nix`
   - `home-manager/modules/dev/fresh.nix`
   - `profiles/amd/default.nix`
   - `profiles/vm/default.nix`
   - `profiles/wsl/default.nix`
   - `profiles/nvidia/default.nix`
   - `profiles/intel/default.nix`
   - `profiles/amd-nvidia/default.nix`
   - `profiles/intel-nvidia/default.nix`
   - `hosts/default/default.nix`
   - `hosts/vm/default.nix`
   - `hosts/wsl/default.nix`
   - `justfile`
   - `install.sh`
   - `README.md`
   - `.sops.yaml`
   - `.github/workflows/cachix.yml`
   - `.github/workflows/lint.yml`

2. **Explore the `mango-waybar/` directory** (cloned into the root of this repo). Read every file:
   - `mango-waybar/config.conf`
   - `mango-waybar/bind.conf`
   - `mango-waybar/env.conf`
   - `mango-waybar/autostart.sh`
   - `mango-waybar/monitor.conf.default`
   - `mango-waybar/tag.conf.default`
   - `mango-waybar/rule.conf.default`
   - `mango-waybar/theme-colors.conf`
   - `mango-waybar/.theme`
   - `mango-waybar/waybar/config.jsonc`
   - `mango-waybar/waybar/scripts/` — ALL scripts
   - `mango-waybar/bars/full/config.jsonc`
   - `mango-waybar/bars/full/style.css.template`
   - `mango-waybar/wofi/config`
   - `mango-waybar/wofi/style.css`
   - `mango-waybar/templates/` — ALL templates
   - `mango-waybar/themes/` — ALL theme directories and their `theme.conf`, `waybar/style.css`, and `kitty/theme.conf` files
   - `mango-waybar/bin/` — ALL scripts (`.sh`, `.py`)

   After reading, summarize your understanding of:
   - How the theme-switching system works end-to-end
   - What each script in `bin/` and `waybar/scripts/` does
   - The structure of a theme definition
   - How waybar config is generated (the Python generator)
   - What wofi does and how it is configured
   - How mako (notification daemon) is configured
   - Which layout modes are supported (tiling, scroller, deck, floating, etc.)

3. **Do NOT make any changes yet.** Only after reading everything should you begin Phase 1.

---

## PHASE 1 — Architecture Plan

Before writing a single `.nix` file, reason through and write out your plan for the following. Show your work.

### 1.1 Desktop Environment Strategy

- Keep **COSMIC** (`modules/desktops/cosmic.nix`) as an available session.
- Add **Mango WM** as a new session (`modules/desktops/mango.nix`).
- Replace the current `modules/desktops/default.nix` so it imports both `cosmic.nix` and `mango.nix`.
- Replace COSMIC's `cosmic-greeter` display manager with **SDDM** using the `sddm-astronaut` theme (see the exact Nix snippet provided in Phase 3 below). Both Mango and COSMIC will appear as selectable sessions in SDDM.
- Remove `services.displayManager.cosmic-greeter.enable = true;` from `cosmic.nix`.
- Do **not** remove `services.desktopManager.cosmic.enable = true;`.

### 1.2 Home Manager Module Layout

New directories and files to create under `home-manager/modules/`:

```
home-manager/modules/
├── mango/
│   ├── default.nix          # imports all mango sub-modules
│   ├── config.nix           # mango WM core config (config.conf, env.conf, bind.conf translated)
│   ├── monitor.nix          # monitor config (single laptop display)
│   ├── tags.nix             # tag/workspace layout config
│   ├── rules.nix            # window rules
│   └── scripts/
│       ├── autostart.nix    # autostart.sh as Nix (writeShellScript / home.file)
│       ├── theme-switch.nix # switch-theme.sh + wall-select.py as Nix
│       ├── screenshot.nix   # screenshot.sh as Nix
│       ├── notifications.nix# notifications.sh as Nix (mako config too)
│       └── waybar-gen.nix   # generate-waybar-config.py as Nix (writeText / home.file)
├── waybar/
│   ├── default.nix          # imports config.nix and style.nix
│   ├── config.nix           # waybar JSON config as Nix (programs.waybar.settings)
│   └── style.nix            # waybar CSS as Nix (programs.waybar.style)
├── wofi/
│   ├── default.nix
│   └── config.nix           # wofi config + CSS (programs.wofi or home.file)
└── misc/
    ├── default.nix          # already exists — add imports for new files
    ├── mime.nix             # already exists
    ├── gtk.nix              # GTK 3/4 theming via home-manager gtk module
    ├── qt.nix               # Qt theming via home-manager qt module
    └── dconf.nix            # dconf settings if needed for GNOME/COSMIC compat
```

### 1.3 Script Handling Strategy

All shell scripts from `mango-waybar/bin/` and `mango-waybar/waybar/scripts/` must be translated into Nix using one of these patterns (choose the most appropriate per script):

- **`pkgs.writeShellScriptBin "script-name" ''...''`** — for scripts that should be on `$PATH` (put in `home.packages`)
- **`home.file.".config/mango/bin/script-name.sh".text = ''...''`** combined with `home.file.".config/mango/bin/script-name.sh".executable = true;` — for scripts that live at a fixed config path
- **`pkgs.writeTextFile { name = "..."; executable = true; destination = "/bin/..."; text = ''...''; }`** — for Python scripts

Do **not** use symlinks. Do **not** reference the `mango-waybar/` directory anywhere in the Nix output.

For Python scripts (e.g., `generate-waybar-config.py`, `wall-select.py`): wrap them with `pkgs.writeShellScriptBin` that calls `${pkgs.python3}/bin/python3 ${pkgs.writeText "script.py" ''...python source...''}`.

### 1.4 Theme System

Translate the theme system into Nix as follows:

- Each theme (gruvbox, catppuccin-pink, catppuccin-purple, monochrome, etc. — read all from `mango-waybar/themes/`) becomes a Nix attribute set in `home-manager/modules/mango/scripts/theme-switch.nix`.
- The `switch-theme.sh` script (which applies GTK theme, icon theme, cursor, wallpaper, regenerates waybar/wofi/mako/kitty config from templates) is translated into a `pkgs.writeShellScriptBin "switch-theme"` that:
  - Uses `gsettings` for GTK/icon/cursor switching
  - Writes waybar style and restarts waybar
  - Uses `swww` or `awww` for wallpaper
  - References colors from the chosen theme
- The interactive theme picker (`SUPER+SHIFT+T`) calls `switch-theme` via wofi or a custom GTK picker (translate `wall-select.py` logic).
- **Preserve the Catppuccin Mocha theme** as the default (already used in your Stylix and zellij config).
- Replace `Bibata-Modern-Ice` cursor with `apple-cursor` (`pkgs.apple-cursor`, name `"Macintosh"`) — already set in `modules/core/stylix.nix`. Ensure GTK/Qt cursor theme name is `"Macintosh"` consistently.

### 1.5 Waybar

Translate `mango-waybar/bars/full/config.jsonc` into `programs.waybar.settings` (Nix attribute set). **Adapt for a single laptop monitor** — remove any multi-monitor output logic; set `output = null` (or omit) so waybar auto-detects the single display.

Translate `mango-waybar/bars/full/style.css.template` into `programs.waybar.style` as a Nix string, with theme color variables substituted using the active Stylix/Catppuccin Mocha palette from `config.lib.stylix.colors.*`. Preserve all visual styling: pill shapes, module colors, fonts, spacing, shadows.

Preserve the **layout switcher module** (the button/widget that lets you switch between tiling, scroller, floating, deck layouts in Mango WM). This is a custom module — translate its script into Nix.

The waybar fedora/distro logo script: replace with a NixOS logo script (use the  nerd font NixOS glyph `""` or an SVG). Keep the accent-color theming logic.

### 1.6 Packages to Add

In `home-manager/modules/mango/default.nix`, declare the following `home.packages`:

```
# Required by mango-waybar
waybar          # (also enabled via programs.waybar)
wofi
mako
grim
slurp
wl-clipboard
imagemagick
jq
libnotify
swww            # OR awww for wallpaper daemon
wlogout
crystal-dock    # if in nixpkgs; otherwise use fetchurl/buildFHSEnv
python3
python3Packages.pygobject3
gtk3
gtk4
```

Also add at the system level in `modules/desktops/mango.nix`:
```
services.gnome.gnome-keyring.enable = true;  # for password prompts
xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
```

Do NOT add: steam, obs, zed, helix, yazi (already in config), discord, telegram, qutebrowser, kdenlive, nemo.

### 1.7 Keybinds

Translate `mango-waybar/bind.conf` into `home-manager/modules/mango/config.nix`. Replace:
- `kitty` → `ghostty` (your terminal)
- `kitty --class floating` → `ghostty --class=floating`
- Remove keybinds for optional apps not being added (steam, obs, zed, helix standalone, discord, telegram, qutebrowser, kdenlive, nemo)
- Keep: `SUPER+Return` → ghostty, `SUPER+Space` → wofi, `SUPER+B` → helium, `SUPER+SHIFT+S` → screenshot, `SUPER+SHIFT+T` → switch-theme, `SUPER+SHIFT+W` → wall-select, `SUPER+SHIFT+Q` → wlogout
- Keep all window management, workspace, layout, gap, and mouse keybinds

### 1.8 Monitor Config

Single integrated laptop display. In `home-manager/modules/mango/monitor.nix`, generate a `home.file.".config/mango/monitor.conf"` with:
```
monitorrule=name:,width:0,height:0,refresh:0,x:0,y:0,scale:1,rr:0
```
(empty name = auto-detect, 0 = use native resolution/refresh)

### 1.9 Linting & Dead Code Rules

Every `.nix` file you produce MUST:
- Pass `alejandra` formatting (2-space indentation, trailing newlines, etc.)
- Have zero unused variables (no `deadnix` warnings) — every argument in the function signature must be used, or must be removed from the signature
- Use `lib.mkIf`, `lib.mkForce`, `lib.mkDefault` where appropriate
- Not duplicate packages already declared elsewhere in the config
- Not import files that don't exist

---

## PHASE 2 — Implementation

Now implement everything from Phase 1. Write each file completely. For each file, state its path relative to the repo root before showing the content.

### Strict Rules

1. **No symlinks.** All config is expressed as Nix.
2. **No `mango-waybar/` references** in any output `.nix` file — that directory will be deleted.
3. **Keep existing modules untouched unless explicitly required:**
   - Do NOT modify: `home-manager/modules/cli/*`, `home-manager/modules/dev/*`, `home-manager/modules/shell/*`, `home-manager/modules/programs/*`, `modules/core/*` (except where SDDM replaces cosmic-greeter — see below), `modules/drivers/*`, `profiles/*`, `flake.nix`, `flake.lock`, `.sops.yaml`, `secrets/`, `hosts/*/hardware-configuration.nix`
4. **Preserve these exactly as-is:** starship config, fastfetch config, fish config (including nixw function, keybinds, shellAbbrs), bash config, ghostty config, warp config, helium config, zen config, zellij config, yazi config, fzf config, zoxide config, eza config, bat config, git config, lazygit, fresh editor, all CLI tools, all dev tools
5. **stylix.nix (home-manager):** keep as-is. Stylix colors from `config.lib.stylix.colors` SHOULD be used in waybar style and fish theme — already done. Do not re-enable targets that are disabled.
6. **Cursor:** use `apple-cursor` (`pkgs.apple-cursor`, name `"Macintosh"`) everywhere — in GTK, Qt, Stylix (already set), and in the theme switch script.
7. **No em dashes (—) in comments or strings inside Nix files.**

### Files to Write

Write these files **in order**:

#### A. `modules/desktops/mango.nix`

System-level Mango WM enablement:
```nix
{ pkgs, ... }: {
  # Enable Mango WM (River-based Wayland compositor)
  # mango is available in nixpkgs as pkgs.mango (check current nixpkgs name)
  # If not in nixpkgs, use the flake input pattern shown below
  programs.mango.enable = true;   # adjust based on actual nixpkgs API

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.common.default = "*";
  };

  services.gnome.gnome-keyring.enable = true;
}
```
> **Note:** Check whether `programs.mango` or `services.mango` is the correct NixOS option. If Mango is not yet in nixpkgs, add it as a package via `environment.systemPackages = [ pkgs.mango ]` and explain that a flake input may be needed. Do NOT invent options that don't exist.

#### B. `modules/desktops/cosmic.nix` (modified)

Remove `services.displayManager.cosmic-greeter.enable = true;`. Keep `services.desktopManager.cosmic.enable = true;`. That's the only change.

#### C. `modules/desktops/sddm.nix` (new)

Implement the SDDM astronaut theme exactly as provided:

```nix
{
  pkgs,
  config,
  lib,
  ...
}:
let
  foreground = config.lib.stylix.colors.base00;
  textColor = config.lib.stylix.colors.base05;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig =
      if lib.hasSuffix "sakura_static.png" (toString config.stylix.image) then
        {
          FormPosition = "left";
          Blur = "2.0";
          HourFormat = "h:mm AP";
        }
      else if lib.hasSuffix "studio.png" (toString config.stylix.image) then
        {
          Background = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/anotherhadi/nixy-wallpapers/refs/heads/main/wallpapers/studio.gif";
            sha256 = "sha256-qySDskjmFYt+ncslpbz0BfXiWm4hmFf5GPWF2NlTVB8=";
          };
          HeaderTextColor = "#${textColor}";
          DateTextColor = "#${textColor}";
          TimeTextColor = "#${textColor}";
          HourFormat = "h:mm AP";
          LoginFieldTextColor = "#${textColor}";
          PasswordFieldTextColor = "#${textColor}";
          UserIconColor = "#${textColor}";
          PasswordIconColor = "#${textColor}";
          WarningColor = "#${textColor}";
          LoginButtonBackgroundColor = "#${foreground}";
          SystemButtonsIconsColor = "#${foreground}";
          SessionButtonTextColor = "#${textColor}";
          VirtualKeyboardButtonTextColor = "#${textColor}";
          DropdownBackgroundColor = "#${foreground}";
          HighlightBackgroundColor = "#${textColor}";
        }
      else
        {
          FormPosition = "left";
          Blur = "4.0";
          Background = "${toString config.stylix.image}";
          HeaderTextColor = "#${textColor}";
          DateTextColor = "#${textColor}";
          TimeTextColor = "#${textColor}";
          HourFormat = "h:mm AP";
          LoginFieldTextColor = "#${textColor}";
          PasswordFieldTextColor = "#${textColor}";
          UserIconColor = "#${textColor}";
          PasswordIconColor = "#${textColor}";
          WarningColor = "#${textColor}";
          LoginButtonBackgroundColor = "#${config.lib.stylix.colors.base01}";
          SystemButtonsIconsColor = "#${textColor}";
          SessionButtonTextColor = "#${textColor}";
          VirtualKeyboardButtonTextColor = "#${textColor}";
          DropdownBackgroundColor = "#${config.lib.stylix.colors.base01}";
          HighlightBackgroundColor = "#${textColor}";
          FormBackgroundColor = "#${config.lib.stylix.colors.base01}";
        };
  };
in
{
  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm;
    extraPackages = [ sddm-astronaut ];
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
  };
  environment.systemPackages = [ sddm-astronaut ];
}
```

#### D. `modules/desktops/default.nix` (rewritten)

```nix
{ ... }: {
  imports = [
    ./cosmic.nix
    ./mango.nix
    ./sddm.nix
  ];
}
```

#### E. `home-manager/modules/mango/default.nix`

Import all mango sub-modules.

#### F. `home-manager/modules/mango/config.nix`

Translate `config.conf`, `env.conf`, `monitor.conf.default`, `tag.conf.default`, `rule.conf.default`, and `bind.conf` into `home.file` entries. For `bind.conf`, apply the terminal replacement (kitty → ghostty) and keybind filtering rules from Phase 1.7.

#### G. `home-manager/modules/mango/monitor.nix`

Single laptop display config.

#### H. `home-manager/modules/mango/scripts/autostart.nix`

Translate `autostart.sh` into a `pkgs.writeShellScriptBin "mango-autostart"`. Remove kitty references. Add ghostty if it was referenced. Keep: awww/swww wallpaper daemon start, waybar start (via `switch-theme --apply`), mako start, kdeconnect indicator, any XDG portal setup. The autostart script should be referenced in the mango `config.conf` as the autostart entry.

#### I. `home-manager/modules/mango/scripts/theme-switch.nix`

Translate `bin/switch-theme.sh` and `bin/wall-select.py` into Nix. Define each theme (gruvbox, catppuccin-mocha, catppuccin-pink, catppuccin-purple, monochrome, material-black, graphite-dark — read all from `mango-waybar/themes/`) as shell variable blocks inside the script. The script must:
- Accept a theme name as argument, or show an interactive wofi/dmenu picker
- Apply GTK theme via `gsettings`
- Apply icon theme via `gsettings`
- Apply cursor theme as `"Macintosh"` (always — do not change cursor per theme since we pin it)
- Write `~/.config/mango/.theme`
- Generate waybar style from template and restart waybar: `pkill waybar; waybar &`
- Apply wallpaper via `awww` or `swww img`
- For wall-select: use `pkgs.writeShellScriptBin "wall-select"` that calls a Python script for the GTK grid picker

#### J. `home-manager/modules/mango/scripts/screenshot.nix`

Translate `bin/screenshot.sh` → `pkgs.writeShellScriptBin "mango-screenshot"`. Uses `grim` + `slurp`. Saves to `~/Pictures/Screenshots/`. Sends libnotify notification.

#### K. `home-manager/modules/mango/scripts/notifications.nix`

Translate mako notification daemon config into `services.mako` (Home Manager mako module). Apply Catppuccin Mocha colors from `config.lib.stylix.colors`. Translate any `notifications.sh` script from `mango-waybar/waybar/scripts/` into a `pkgs.writeShellScriptBin "mango-notifications"`.

#### L. `home-manager/modules/mango/scripts/waybar-gen.nix`

Translate `bin/generate-waybar-config.py` into a `pkgs.writeShellScriptBin "waybar-gen"` that runs the Python source inline. **Simplify for single monitor** — strip the multi-monitor detection logic; just output a single waybar config for the integrated display.

#### M. `home-manager/modules/waybar/default.nix`, `config.nix`, `style.nix`

Translate `mango-waybar/bars/full/config.jsonc` into `programs.waybar.settings`. Key points:
- `programs.waybar.enable = true`
- Single output (remove multi-monitor logic)
- Preserve all modules: workspaces, layout switcher, clock, battery, network, volume, bluetooth, system tray, CPU, memory, custom logo
- Layout switcher module: translate the script from `mango-waybar/bin/` that cycles Mango WM layouts (tiling, scroller, floating, deck, etc.)
- NixOS logo module: replace Fedora logo with NixOS nerd font glyph `""`, keep accent-color theming
- Translate CSS template into `programs.waybar.style`, substituting Catppuccin Mocha hex values from `config.lib.stylix.colors`. Preserve pill modules, shadows, fonts (use DepartureMono from Stylix), rounded corners.

#### N. `home-manager/modules/wofi/default.nix`, `config.nix`

Translate `mango-waybar/wofi/config` and `mango-waybar/wofi/style.css` into:
- `programs.wofi.enable = true`
- `programs.wofi.settings` (the config key=value pairs)
- `programs.wofi.style` (the CSS, with Catppuccin Mocha colors)

#### O. `home-manager/modules/misc/gtk.nix`

```nix
{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };
    iconTheme = {
      name = "Tela-dark";
      package = pkgs.tela-icon-theme;
    };
    cursorTheme = {
      name = "Macintosh";
      package = pkgs.apple-cursor;
      size = 24;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };
  home.sessionVariables.GTK_THEME = "Graphite-Dark";
}
```

#### P. `home-manager/modules/misc/qt.nix`

```nix
{ pkgs, ... }: {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
```

#### Q. `home-manager/modules/misc/dconf.nix`

```nix
{ lib, ... }: {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = lib.mkDefault "Graphite-Dark";
      icon-theme = lib.mkDefault "Tela-dark";
      cursor-theme = lib.mkDefault "Macintosh";
      cursor-size = lib.mkDefault 24;
      color-scheme = lib.mkDefault "prefer-dark";
    };
  };
}
```

#### R. `home-manager/modules/misc/default.nix` (updated)

Add imports for `gtk.nix`, `qt.nix`, `dconf.nix`.

#### S. `home-manager/modules/default.nix` (updated)

Add `./mango`, `./waybar`, `./wofi` to imports.

#### T. Cleanup: `modules/desktops/` final state

Only these files should exist:
- `default.nix` (imports cosmic, mango, sddm)
- `cosmic.nix` (modified — no cosmic-greeter)
- `mango.nix` (new)
- `sddm.nix` (new)

Delete `mango-waybar/` entirely (instruct the user to run `rm -rf mango-waybar/`).

#### U. `install.sh` (updated)

- Update the success banner to mention SDDM + COSMIC / Mango WM session choice at login
- Update the "Desktop Setup Complete" section to say: "SDDM display manager enabled", "COSMIC desktop available", "Mango WM available", "Select your session at login"
- Remove all references to "COSMIC greeter"
- Keep everything else identical

#### V. `README.md` (updated)

Update the following sections:
- **Key Features**: Replace "COSMIC Desktop (from System76)" bullet with two bullets: "**COSMIC Desktop** (System76) — modern Wayland DE" and "**Mango WM** — tiling Wayland compositor with themed waybar". Add "**SDDM** display manager with sddm-astronaut theme, supporting both sessions".
- **Structure**: Add entries for `modules/desktops/mango.nix`, `modules/desktops/sddm.nix`, `home-manager/modules/mango/`, `home-manager/modules/waybar/`, `home-manager/modules/wofi/`.
- **Daily Commands**: keep identical.
- **GPU Profiles table**: keep identical.
- Remove any leftover references to cosmic-greeter.

---

## PHASE 3 — Commit & Rebuild Instructions

After writing all files, output exactly the following (do not execute any git or nix commands yourself):

### Git Commit Message

```
feat(desktop): replace cosmic-greeter with sddm-astronaut and add mango WM session

- add modules/desktops/mango.nix: Mango WM system-level enablement with
  xdg-desktop-portal-wlr and gnome-keyring
- add modules/desktops/sddm.nix: SDDM with sddm-astronaut theme (pixel_sakura),
  Stylix-integrated colors, both COSMIC and Mango WM sessions selectable at login
- update modules/desktops/cosmic.nix: remove cosmic-greeter, keep COSMIC DE
- add home-manager/modules/mango/: full Mango WM home config - config, keybinds,
  monitor (single laptop display), tags, window rules
- add home-manager/modules/mango/scripts/: autostart, theme-switch, wall-select,
  screenshot, mako notifications, waybar-gen - all as Nix (no symlinks)
- add home-manager/modules/waybar/: programs.waybar with Catppuccin Mocha styling,
  layout switcher, NixOS logo module, single-monitor config
- add home-manager/modules/wofi/: programs.wofi with Catppuccin Mocha CSS
- add home-manager/modules/misc/gtk.nix: GTK 3/4 theme (Graphite-Dark), Tela icons,
  Macintosh cursor via apple-cursor
- add home-manager/modules/misc/qt.nix: Qt theme (adwaita-dark, gtk platform)
- add home-manager/modules/misc/dconf.nix: dconf GTK/icon/cursor/dark-mode settings
- terminal: kitty replaced with ghostty throughout mango keybinds
- cursor: Bibata replaced with apple-cursor (Macintosh) throughout
- remove mango-waybar/ dotfiles directory (fully translated to Nix)
- update install.sh: reflect SDDM + dual-session setup
- update README.md: document new desktop architecture
```

### Justfile Command to Run

```bash
just switch
```

Run this after staging all changes (`git add -A`). If you encounter evaluation errors, report them and I will fix them before rebuilding.

---

## PHASE 4 — Linting Checklist

Before presenting your output, verify each file against these rules. Fix any violation before output:

- [ ] Every function argument that is accepted but not used is removed from the argument set
- [ ] `pkgs` is only in the argument set if `pkgs.*` is referenced in the file body
- [ ] `lib` is only in the argument set if `lib.*` is used
- [ ] `config` is only in the argument set if `config.*` is used
- [ ] `inputs`, `vars`, `host`, `profile`, `fresh`, `helium`, `zen-browser` are only in the argument set of files that actually use them
- [ ] No `let x = ...; in ...` where `x` is never referenced
- [ ] `alejandra`-compatible formatting: 2-space indent, `{` on same line as `=`, trailing newline
- [ ] No inline `--` (double dash) in strings that are comments in other languages — use `#` in Nix
- [ ] Packages not in nixpkgs are clearly flagged with a `# TODO: verify nixpkgs attribute name` comment
- [ ] The `mango-waybar/` path appears NOWHERE in any `.nix` file

---

## FINAL NOTE TO GEMINI

When you are done writing all files:
1. List every file path you created or modified.
2. List any packages you used that you are not 100% certain exist in `nixpkgs-unstable` as of mid-2026, and flag them clearly so the user can verify with `nix search nixpkgs <name>`.
3. List any NixOS or Home Manager module options you used that may not exist and should be verified with `man configuration.nix` or `man home-configuration.nix`.
4. Do NOT run `git`, `nixos-rebuild`, `nix build`, or any destructive shell commands.
5. Do NOT delete `mango-waybar/` yourself — instruct the user to run `rm -rf mango-waybar/ GEMINI.md` after reviewing your output.
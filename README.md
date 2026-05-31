<p align="center"><img src="https://i.imgur.com/X5zKxvp.png" width=300px></p>

# Modular NixOS & Home Manager Configuration
tagline: Flakes · Home Manager · Stylix · COSMIC · MangoWC

## Key Features
- Multi-GPU Support (AMD, Intel, NVIDIA, hybrid Prime)
- COSMIC Desktop (System76) — default graphical session
- MangoWC — lightweight Wayland compositor, always enabled alongside COSMIC
- Home Manager — complete user environment
- Theming — Stylix catppuccin-mocha system-wide; noctalia bar/launcher/notifications
- Security — SOPS-nix age secrets
- Automation — justfile + install.sh with hardware auto-detection
- WSL support

## Structure
hosts/                    host-specific settings (default, vm, wsl)
modules/core/             base system services and settings
modules/drivers/          GPU and VM driver options
modules/desktops/         COSMIC and MangoWC desktop modules
profiles/                 entry points mapping profiles to hosts and drivers
home-manager/
  modules/cli/            CLI tools (starship, fastfetch, fzf, bat, eza...)
  modules/dev/            dev tools (terraform, ansible, cloud CLIs, languages)
  modules/programs/       GUI apps (ghostty, warp, helium, zen, thunderbird)
  modules/shell/          fish + bash configuration
  modules/mango/          MangoWC config and autostart scripts
  modules/rofi/           rofi launcher with noctalia theme
  modules/noctalia/       bar, dunst notifications, wallpaper daemon
  modules/misc/           MIME types, dconf, GTK theming, QT theming
  modules/kdeconnect/     KDE Connect

## Usage
### Installation
1.  **Boot a NixOS installer** (any recent ISO).
2.  **Clone this repository**:
    ```bash
    nix-shell -p git --run "git clone https://github.com/melek/nixos.git ~/nixos"
    cd ~/nixos
    ```
3.  **Run the install script**:
    ```bash
    ./install.sh
    ```
    The script will auto-detect your hardware and suggest the best profile.

### Daily Commands
Manage your system using `just`:
- `just build` — Test the build without switching
- `just switch` — Apply changes to the current system
- `just update` — Update flake locks and switch
- `just clean` — Garbage collect old generations
- `just check` — Run flake evaluation checks

## GPU Profiles
| Profile        | Description                                  |
|----------------|----------------------------------------------|
| `amd`          | AMD GPU only                                 |
| `nvidia`       | NVIDIA GPU only                              |
| `intel`        | Intel GPU only                               |
| `amd-nvidia`   | Hybrid AMD + NVIDIA (Prime)                  |
| `intel-nvidia` | Hybrid Intel + NVIDIA (Prime)                |
| `vm`           | Virtual Machine (QEMU/KVM guest services)    |
| `wsl`          | Windows Subsystem for Linux                  |

## MangoWC Keybindings
| Key                    | Action                   |
|------------------------|--------------------------|
| Super+Return           | Ghostty terminal         |
| Super+b                | Helium browser           |
| Super+z                | Zen browser              |
| Super+a                | Antigravity              |
| Super+w                | Warp terminal            |
| Super+e                | File manager             |
| Super+Space            | Rofi app launcher        |
| Super+q                | Close window             |
| Super+h/j/k/l          | Focus left/down/up/right |
| Super+Shift+h/j/k/l    | Move window              |
| Super+BackSpace        | Logout                   |

## License
Personal configuration. Use at your own risk.

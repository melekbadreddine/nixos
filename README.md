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
```text
/home/melek/nixos/
├── flake.nix               # Entry point
├── hosts/                  # Host configurations (default, vm, wsl)
├── modules/
│   ├── core/               # Base system services (SDDM, I18N, ENV)
│   ├── desktops/           # Desktop managers (COSMIC, Mango)
│   └── drivers/            # GPU drivers (AMD, Intel, NVIDIA)
├── profiles/               # Hardware profiles
├── home-manager/
│   ├── home.nix            # Main HM entry point
│   └── modules/
│       ├── cli/            # CLI tools (fastfetch, git, yazi)
│       ├── mango/          # MangoWC user config
│       ├── noctalia/       # Noctalia panel/bar config
│       ├── programs/       # GUI apps (zen, ghostty, vesktop)
│       ├── rofi/           # Rofi launcher config
│       └── shell/          # fish + bash config
├── assets/                 # Wallpapers and themes
└── secrets/                # SOPS-nix encrypted secrets
```

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
- `just switch` — Apply changes to the current system (auto-detects profile)
- `just home-switch` — Apply Home Manager changes only
- `just update` — Update flake locks and switch
- `just clean` — Garbage collect old generations
- `just check` — Run flake evaluation checks
- `just format` — Format all Nix files with Alejandra

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
| Key                            | Action                   |
|--------------------------------|--------------------------|
| Super+Return                   | Ghostty terminal         |
| Super+h                        | Helium browser           |
| Super+z                        | Zen browser              |
| Super+a                        | Antigravity              |
| Super+w                        | Warp terminal            |
| Super+f                        | PCManFM-Qt file manager  |
| Super+Space                    | Rofi app launcher        |
| Super+v                        | Virt-Manager             |
| Super+q                        | Close window             |
| Super+Left/Down/Up/Right       | Focus left/down/up/right |
| Super+Shift+Left/Down/Up/Right | Move window              |
| Super+BackSpace                | Logout                   |

## License
Personal configuration. Use at your own risk.

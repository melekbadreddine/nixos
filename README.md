# Modular NixOS & Home Manager Configuration

A highly modular, hardware-aware NixOS configuration using Flakes, Home Manager, and Stylix. Features automatic GPU detection and COSMIC Desktop (from System76).

## 🚀 Key Features

- **Multi-GPU Support**: Profiles for AMD, Intel, NVIDIA, and hybrid (Prime) setups.
- **COSMIC Desktop (from System76)**: Modern Wayland-native desktop environment.
- **Home Manager**: Complete user environment management.
- **Theming**: Integrated theming via **Stylix** (Ayu Dark) with custom Catppuccin Mocha palettes for Starship and Zellij.
- **Security**: Secret management via **SOPS-nix** (age).
- **Automation**: `justfile` for quick rebuilds and `install.sh` for hardware auto-detection.
- **WSL Support**: Native NixOS-WSL profile for Windows integration.

## 📂 Structure

- `hosts/`: Host-specific settings (default, vm, wsl).
- `modules/core/`: Base system services and settings.
- `modules/drivers/`: Reusable GPU and VM driver options.
- `modules/desktops/mango.nix`: Mango WM system configuration.
- `modules/desktops/sddm.nix`: SDDM display manager configuration.
- `home-manager/modules/mango/`: Mango WM user configuration.
- `home-manager/modules/waybar/`: Waybar configuration.
- `home-manager/modules/wofi/`: Wofi configuration.
- `home-manager/modules/misc/`: GTK, Qt, and dconf settings.
- `profiles/`: Entry points mapping profiles to hosts and drivers.
- `home-manager/`: User-level configuration (CLI, Dev, Programs, Shell).

## 🛠️ Usage

### Installation

1. Boot into a NixOS live environment or existing install.
2. Enter a shell with required tools: `nix-shell -p git pciutils`
3. Clone this repo: `git clone https://github.com/melekbadreddine/nixos.git && cd nixos`
4. Run the installer: `./install.sh`
5. Reboot and enjoy!

### Daily Commands

We use `just` for automation:

- `just switch`: Rebuild and apply system configuration (auto-detects profile).
- `just home-switch`: Rebuild and apply Home Manager configuration.
- `just update`: Update all flake inputs and rebuild.
- `just clean`: Garbage collect and remove old generations.
- `just check`: Run evaluation and format checks.

## 🔧 GPU Profiles

| Profile | Hardware | Description |
|---------|----------|-------------|
| `amd` | AMD GPU | Standard AMD discrete graphics. |
| `intel` | Intel iGPU | Integrated Intel graphics. |
| `nvidia` | NVIDIA GPU | Discrete NVIDIA graphics (Proprietary). |
| `intel-nvidia` | Intel + NVIDIA | Laptop hybrid setup (PRIME offload). |
| `amd-nvidia` | AMD + NVIDIA | Hybrid setup with AMD iGPU + NVIDIA dGPU. |
| `vm` | Virtual Machine | Optimized for QEMU/VirtualBox. |
| `wsl` | WSL2 | Windows Subsystem for Linux integration. |

## ⌨️ Mango WM Keybindings

| Keybind | Action |
|---------|--------|
| `SUPER + Return` | Launch Ghostty terminal |
| `SUPER + CTRL + Return` | Launch floating Ghostty terminal |
| `SUPER + Space` | Launch Wofi app runner |
| `SUPER + Q` | Kill focused window |
| `SUPER + SHIFT + Q` | Open session menu (wlogout) |
| `SUPER + SHIFT + T` | Switch theme (Interactive) |
| `SUPER + SHIFT + W` | Select wallpaper (Interactive) |
| `SUPER + Y` | Open Yazi file manager |
| `SUPER + B` | Open Helium browser |
| `SUPER + Arrow Keys` | Move focus |
| `SUPER + SHIFT + Arrow Keys`| Move window |
| `SUPER + 1-9` | Switch tag (workspace) |
| `SUPER + SHIFT + 1-9` | Move window to tag |
| `ALT + Tab` | Toggle overview |
| `ALT + F` | Toggle fullscreen |
| `ALT + Z` | Toggle scratchpad |
| `SUPER + SHIFT + S` | Take screenshot (Area selection) |
| `CTRL + Space` | Cycle tiling layouts |
| `CTRL + SHIFT + Space` | Open layout picker (Interactive) |
| `SUPER + ALT + R` | Reload Mango WM config |

## 📜 License

Personal configuration. Use at your own risk.

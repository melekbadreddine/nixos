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
- `modules/desktops/`: Desktop environment configurations.
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

## 📜 License

Personal configuration. Use at your own risk.

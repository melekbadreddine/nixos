# NixOS Configuration with KDE Plasma 6

A modular, hardware-aware NixOS configuration with automatic GPU driver detection and KDE Plasma 6.

## Features

- 🎮 **Multi-GPU Support**: Automatic detection and configuration for AMD, Intel, NVIDIA, and hybrid setups
- 🪟 **Desktop Environment**: KDE Plasma 6 (Wayland by default)
- 🔧 **Modular Design**: Clean separation of concerns with profiles, drivers, and device-specific modules
- 🤖 **Automated Installation**: Hardware auto-detection, configuration generation, and one-command build

## Quick Start

### Prerequisites

You need to be running NixOS with internet access.

### Installation

1. **Enter Nix shell with required tools:**
   ```bash
   nix-shell -p git pciutils
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/melekbadreddine/nixos.git
   cd nixos
   ```

3. **Run the installation script:**
   ```bash
   ./install.sh
   ```

4. **Reboot:**
   ```bash
   sudo reboot
   ```

## GPU Profiles

The installer automatically detects your hardware and selects the appropriate profile:

| Profile | Hardware | Use Case |
|---------|----------|----------|
| `amd` | AMD GPU | Desktop with AMD discrete GPU |
| `intel` | Intel iGPU | Integrated graphics only |
| `nvidia` | NVIDIA GPU | Desktop with NVIDIA discrete GPU |
| `intel-nvidia` | Intel iGPU + NVIDIA dGPU | Laptop with PRIME offload |
| `amd-nvidia` | AMD iGPU + NVIDIA dGPU | Hybrid AMD+NVIDIA system |
| `vm` | Virtual Machine | QEMU, VirtualBox, Hyper-V, etc. |

## File Structure

```
nixos/
├── README.md (this file)
├── flake.nix (multi-profile configuration)
├── install.sh (automated installation)
├── modules/
│   ├── drivers/ (GPU driver modules)
│   ├── desktops/ (KDE Plasma module)
│   ├── core/ (system core modules)
│   └── ...
├── profiles/ (GPU profiles)
├── hosts/default/ (host-specific configuration)
└── home-manager/ (user environment)
```

## License

This configuration is provided as-is for personal use.

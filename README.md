# NixOS Configuration with Mangowc

A modular, hardware-aware NixOS configuration with automatic GPU driver detection and setup.

## Features

- 🎮 **Multi-GPU Support**: Automatic detection and configuration for AMD, Intel, NVIDIA, and hybrid setups
- 🪟 **Mangowc Desktop**: Wayland-based tiling window manager with Tofi launcher and Waybar statusbar
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

4. **Follow the prompts:**
   - Script automatically detects your hardware
   - Confirm or override the detected GPU profile
   - Review the summary and confirm to proceed
   - System will build and prepare for reboot

5. **Reboot:**
   ```bash
   sudo reboot
   ```

6. **At login screen:**
   - Login with tuigreet (login manager)
   - Select Mango from session menu
   - Enjoy Mangowc!

## What Gets Installed

### System Configuration
- ✅ Automatic hardware configuration generation (`nixos-generate-config`)
- ✅ GPU drivers (AMD, Intel, NVIDIA, or hybrid)
- ✅ Greetd login manager with tuigreet TUI

### Desktop Environment
- ✅ Mango window manager (Wayland compositor)
- ✅ Tofi application launcher (SUPER+w)
- ✅ Waybar status bar with system info
- ✅ Alacritty terminal
- ✅ File manager (PCManFM-Qt)
- ✅ Screenshot tool (Wayshot)
- ✅ Image viewer (Swayimg)
- ✅ Sound control (Pavucontrol-Qt)

### Styling
- ✅ Ayu-dark color scheme
- ✅ DepartureMono Nerd Font

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

### Manual Profile Override

If the auto-detection isn't correct, you can manually select a profile during installation.

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| SUPER+w | Application launcher (Tofi) |
| SUPER+t | Terminal (Alacritty) |
| SUPER+[1-9] | Switch workspace |
| SUPER+Shift+[1-9] | Move window to workspace |
| SUPER+h/j/k/l | Focus direction (vim-style) |
| SUPER+Shift+h/j/k/l | Swap windows |
| SUPER+f | Toggle fullscreen |
| SUPER+space | Switch layout |
| SUPER+0 | Toggle overview |
| Print | Screenshot |
| SUPER+Shift+u | Power off |
| SUPER+Shift+r | Reboot |
| Ctrl+Alt+Space | Exit Mango |

## Advanced Usage

### Rebuild System

After modifying configuration:

```bash
# Boot into new config (requires reboot)
sudo nixos-rebuild boot --flake ".#amd-nvidia"

# Switch immediately (if compatible)
sudo nixos-rebuild switch --flake ".#intel-nvidia"
```

### Change GPU Profile

1. Edit `flake.nix` and change profile name, or
2. Run installation script again with new profile

### Customize Configuration

- **Styling**: Edit `modules/stylix.nix`
- **Desktop**: Edit `modules/desktops/mango.nix`
- **Drivers**: Edit profile in `profiles/${profile}/default.nix`
- **Packages**: Edit `home-manager/modules/gui/packages.nix`

### Check Hardware Configuration

View your generated hardware configuration:

```bash
cat hosts/default/hardware-configuration.nix
```

Check GPU Bus IDs:

```bash
lspci -v | grep -i "vga\|3d"
```

## Troubleshooting

### Installation Script Fails

**Symptoms**: `nixos-rebuild` returns an error

**Solution**:
1. Check the log file (printed at end of script output)
2. Verify GPU Bus IDs match your hardware:
   ```bash
   lspci -v | grep -i "vga\|3d"
   ```
3. Update `hosts/default/variables.nix` with correct IDs if needed
4. Run script again

### Hardware Not Detected

**Symptoms**: GPU profile shows as `amd` even if you have Intel

**Solution**:
- Press 'N' when asked if detection is correct
- Manually select your profile from the menu

### Display Issues After Boot

**Symptoms**: Black screen or resolution problems

**Solution**:
1. Check if mango started: `ps aux | grep mango`
2. Check logs: `journalctl -u home-manager-melek -n 50`
3. Verify GPU drivers loaded: `lspci | grep -i vga`

## File Structure

```
nixos/
├── README.md (this file)
├── flake.nix (multi-profile configuration)
├── install.sh (automated installation)
├── modules/
│   ├── drivers/ (GPU driver modules)
│   ├── desktops/mango.nix (Mangowc config)
│   ├── core/ (system core modules)
│   ├── stylix.nix (theming)
│   └── ...
├── profiles/ (GPU profiles)
│   ├── amd/
│   ├── intel/
│   ├── nvidia/
│   ├── intel-nvidia/
│   ├── amd-nvidia/
│   └── vm/
├── hosts/default/ (host-specific configuration)
│   ├── default.nix
│   ├── variables.nix
│   └── hardware-configuration.nix
└── home-manager/ (user environment)
    ├── home.nix
    └── modules/
```

## Support

For issues or questions:
1. Check the log file generated by `install.sh`
2. Review the [NixOS Manual](https://nixos.org/manual/nixos/stable/)
3. Check [Mango Documentation](https://github.com/mangowm/mango)

## License

This configuration is provided as-is for personal use.

## Contributing

Feel free to extend this configuration for your needs!

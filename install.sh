#!/usr/bin/env bash

######################################
# NixOS Installation Script
# Detects hardware, generates config, builds NixOS
# Sets up KDE Plasma 6
######################################

set -e

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Define log file
LOG_DIR="$(dirname "$0")"
LOG_FILE="${LOG_DIR}/install_$(date +"%Y-%m-%d_%H-%M-%S").log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to print a section header
print_header() {
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║ ${1} ${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print a success banner
print_success_banner() {
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║           NixOS Desktop Environment Installation Successful!          ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║   Please reboot your system for changes to take full effect.          ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║   Select your preferred session at the login screen and enjoy!        ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print a failure banner
print_failure_banner() {
  echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║                 NixOS Installation Failed!                            ║${NC}"
  echo -e "${RED}║                                                                       ║${NC}"
  echo -e "${RED}║   Please review the log file for details:                             ║${NC}"
  echo -e "${RED}║   ${LOG_FILE}                                                        ║${NC}"
  echo -e "${RED}║                                                                       ║${NC}"
  echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

print_header "Verifying System Requirements"

# Check for git
if ! command -v git &>/dev/null; then
  echo -e "${RED}Error: Git is not installed.${NC}"
  echo -e "Please install git: nix-shell -p git pciutils"
  exit 1
fi

# Check for lspci (pciutils)
if ! command -v lspci &>/dev/null; then
  echo -e "${RED}Error: pciutils is not installed.${NC}"
  echo -e "Please install pciutils: nix-shell -p git pciutils"
  exit 1
fi

if [ -n "$(grep -i nixos </etc/os-release)" ]; then
  echo -e "${GREEN}✓ Verified this is NixOS.${NC}"
else
  echo -e "${RED}Error: This is not NixOS.${NC}"
  exit 1
fi

print_header "Hardware Detection"

# Detect VM
has_vm=false
detect_vm() {
  if command -v systemd-detect-virt &>/dev/null; then
    if systemd-detect-virt --quiet; then
      return 0
    fi
  fi
  for f in /sys/class/dmi/id/product_name /sys/class/dmi/id/sys_vendor; do
    if [ -r "$f" ] && grep -Eqi 'qemu|kvm|vmware|virtualbox|hyper-v|microsoft corporation|xen|parallels' "$f"; then
      return 0
    fi
  done
  return 1
}

if detect_vm; then
  has_vm=true
fi

# Detect GPUs
has_nvidia=false
has_intel=false
has_amd=false

if lspci | grep -qi 'vga\|3d\|display'; then
  while read -r line; do
    if echo "$line" | grep -Eq '\[10de:|nvidia'; then
      has_nvidia=true
    elif echo "$line" | grep -Eq '\[1002:|amd|ati|advanced micro devices'; then
      has_amd=true
    elif echo "$line" | grep -Eq '\[8086:|intel'; then
      has_intel=true
    elif echo "$line" | grep -Eqi 'virtio|vmware|virtualbox|qxl|hyper-v|parallels|qemu|bochs'; then
      has_vm=true
    fi
  done < <(lspci -nn | grep -i 'vga\|3d\|display')
fi

# Determine profile
DETECTED_PROFILE=""
if $has_vm; then
  DETECTED_PROFILE="vm"
elif $has_amd && $has_nvidia; then
  DETECTED_PROFILE="amd-nvidia"
elif $has_nvidia && $has_intel; then
  DETECTED_PROFILE="intel-nvidia"
elif $has_nvidia; then
  DETECTED_PROFILE="nvidia"
elif $has_amd; then
  DETECTED_PROFILE="amd"
elif $has_intel; then
  DETECTED_PROFILE="intel"
else
  DETECTED_PROFILE="amd"
fi

echo -e "${GREEN}Detected GPU profile: $DETECTED_PROFILE${NC}"
read -p "Correct? (Y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${YELLOW}Manual profile selection:${NC}"
  echo "  • amd - AMD GPU"
  echo "  • intel - Intel iGPU"
  echo "  • nvidia - NVIDIA GPU"
  echo "  • intel-nvidia - Intel iGPU + NVIDIA dGPU"
  echo "  • amd-nvidia - AMD iGPU + NVIDIA dGPU"
  echo "  • vm - Virtual machine"
  read -rp "Enter profile: [ $DETECTED_PROFILE ] " profile
  if [ -z "$profile" ]; then
    profile="$DETECTED_PROFILE"
  fi
else
  profile="$DETECTED_PROFILE"
fi

echo -e "${GREEN}✓ Using profile: $profile${NC}"

print_header "Generating Hardware Configuration"

# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix 2>/dev/null || true

# Backup existing hardware-configuration.nix if it exists
if [ -f "hosts/default/hardware-configuration.nix" ]; then
  BACKUP_NAME="hardware-configuration.nix.backup.$(date +%s)"
  cp hosts/default/hardware-configuration.nix "hosts/default/$BACKUP_NAME"
  echo -e "${YELLOW}Backed up old hardware config to: $BACKUP_NAME${NC}"
fi

# Replace with new hardware configuration
if [ -f "/tmp/hardware.nix" ]; then
  cp /tmp/hardware.nix hosts/default/hardware-configuration.nix
  echo -e "${GREEN}✓ Hardware configuration generated and saved.${NC}"
else
  echo -e "${YELLOW}⚠ Warning: Could not generate hardware config, using existing.${NC}"
fi

print_header "Building NixOS"

# Update flake.nix with selected profile
echo -e "${BLUE}Updating configuration with profile: $profile${NC}"
cp flake.nix flake.nix.bak

# Update profile in flake.nix if it exists as a variable
if grep -q 'profile = ' flake.nix; then
  sed -i "s|profile = \"[^\"]*\"|profile = \"$profile\"|g" flake.nix
fi

echo -e "${GREEN}Ready to build NixOS with profile: $profile${NC}"
read -p "Continue with NixOS rebuild? (Y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${RED}Build cancelled.${NC}"
  mv flake.nix.bak flake.nix
  exit 1
fi

# Set experimental features
export NIX_CONFIG="experimental-features = nix-command flakes"

# Build and boot
echo -e "${BLUE}Building NixOS system...${NC}"
if sudo NIX_CONFIG="$NIX_CONFIG" nixos-rebuild boot --flake ".#$profile" 2>&1; then
  rm flake.nix.bak
  # Write the successful profile to a state file for the justfile to use
  echo "$profile" > "${LOG_DIR}/.current-profile"
  echo -e "${GREEN}✓ NixOS build successful!${NC}"
  
  print_header "Desktop Setup Complete"
  echo -e "${GREEN}✓ Selected desktop manager enabled${NC}"
  echo -e "${GREEN}✓ Display manager configured${NC}"
  echo -e "${GREEN}✓ GPU drivers installed${NC}"
  echo -e "${GREEN}✓ All dependencies installed${NC}"
  
  print_success_banner
else
  mv flake.nix.bak flake.nix
  print_failure_banner
  exit 1
fi

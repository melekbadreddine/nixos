#!/usr/bin/env bash

######################################
# NixOS Installation Script
# Detects hardware, generates config, builds NixOS
# Sets up COSMIC Desktop
######################################

set -e

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Base directories
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${REPO_DIR}"

# Function to print headers
print_header() {
  echo -e "\n${BLUE}==== $1 ====${NC}"
}

# Function to print success banner
print_success_banner() {
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║           NixOS Desktop Environment Installation Successful!          ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║   Please reboot your system for changes to take full effect.          ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║   Log in with the COSMIC greeter and enjoy your desktop!              ║${NC}"
  echo -e "${GREEN}║   Sessions available: COSMIC, MangoWC                                 ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print a failure banner
print_failure_banner() {
  echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║                NixOS Installation Failed!                             ║${NC}"
  echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# 1. Hardware Detection
print_header "Detecting Hardware"
GPU_TYPE="unknown"

# Use lspci to find GPU
if lspci | grep -qi "nvidia"; then
  if lspci | grep -qi "intel" || lspci | grep -qi "amd"; then
    if lspci | grep -qi "intel"; then
      GPU_TYPE="intel-nvidia"
    else
      GPU_TYPE="amd-nvidia"
    fi
  else
    GPU_TYPE="nvidia"
  fi
elif lspci | grep -qi "amd"; then
  GPU_TYPE="amd"
elif lspci | grep -qi "intel"; then
  GPU_TYPE="intel"
fi

# Detect if running in a VM
if systemd-detect-virt -q; then
  GPU_TYPE="vm"
fi

# Detect if running in WSL
if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  GPU_TYPE="wsl"
fi

echo -e "Detected hardware profile: ${YELLOW}${GPU_TYPE}${NC}"

# 2. Preparation
print_header "Preparing Configuration"
cd "${REPO_DIR}"

# Backup existing flake.nix just in case
cp flake.nix flake.nix.bak

# Update profile in flake.nix if needed (simplified detection)
profile="${GPU_TYPE}"

# 3. NixOS Build
print_header "Building NixOS Configuration"
echo "Building profile: ${profile}..."

if sudo nixos-rebuild switch --flake ".#${profile}"; then
  # Write the successful profile to a state file for the justfile to use
  echo "$profile" > "${LOG_DIR}/.current-profile"
  echo -e "${GREEN}✓ NixOS build successful!${NC}"

  print_header "Desktop Setup Complete"
  echo "COSMIC desktop enabled"
  echo "COSMIC greeter configured"
  echo "MangoWC compositor enabled"
  echo -e "${GREEN}✓ GPU drivers installed${NC}"
  echo -e "${GREEN}✓ All dependencies installed${NC}"

  print_success_banner
else
  mv flake.nix.bak flake.nix
  print_failure_banner
  exit 1
fi

# List available commands
default:
    @just --list

# Detect the current profile
profile := `if [ -f .current-profile ]; then cat .current-profile; \
    elif [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then echo "wsl"; \
    elif command -v lspci > /dev/null; then \
    if lspci | grep -qi "nvidia" && lspci | grep -qi "amd"; then echo "amd-nvidia"; \
    elif lspci | grep -qi "nvidia" && lspci | grep -qi "intel"; then echo "intel-nvidia"; \
    elif lspci | grep -qi "nvidia"; then echo "nvidia"; \
    elif lspci | grep -qi "amd"; then echo "amd"; \
    elif lspci | grep -qi "intel"; then echo "intel"; \
    else echo "amd"; fi; \
    else echo "amd"; fi`

# Rebuild the NixOS system
switch:
    @echo "Rebuilding NixOS system with profile: {{profile}}..."
    sudo nixos-rebuild switch --flake .#{{profile}}

# Rebuild Home Manager configuration standalone
home-switch:
    @echo "Rebuilding Home Manager..."
    home-manager switch --flake .#melek

# Update flake inputs and rebuild
update:
    @echo "Updating flake inputs..."
    nix flake update
    @echo "Rebuilding System with profile: {{profile}}..."
    sudo nixos-rebuild switch --flake .#{{profile}}

# Garbage collect and remove result symlinks
clean:
    @echo "Cleaning up..."
    nix-collect-garbage -d
    rm -f result result-*

# Check for flake errors
check:
    nix flake check

# Format Nix files
format:
    alejandra .

# Show git diff
diff:
    git diff

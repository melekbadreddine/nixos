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
    sudo nixos-rebuild switch --flake .#{{profile}} --accept-flake-config

# Rebuild Home Manager configuration standalone
home-switch:
    @echo "Rebuilding Home Manager..."
    @HOST_TARGET=$([ "{{profile}}" = "wsl" ] && echo "wsl" || ([ "{{profile}}" = "vm" ] && echo "vm" || echo "default")); \
    home-manager switch --flake .#melek@$HOST_TARGET --accept-flake-config

# Update all flake inputs and rebuild system
update:
    @echo "Updating flake inputs..."
    nix flake update
    @echo "Rebuilding System with profile: {{profile}}..."
    sudo nixos-rebuild switch --flake .#{{profile}} --accept-flake-config

# Update all flake inputs
update-flake:
    @echo "Updating flake inputs..."
    nix flake update

# Update specific flake input
update-input INPUT:
    @echo "Updating flake input: {{INPUT}}"
    nix flake lock --update-input {{INPUT}}

# Show flake inputs status
show-flake:
    @echo "Flake inputs:"
    nix flake metadata

# Garbage collect and remove result symlinks
clean:
    @echo "Cleaning up..."
    nix-collect-garbage -d
    rm -f result result-*

# Check for flake errors and dead code
check:
    nix flake check --accept-flake-config
    nix run nixpkgs#deadnix -- --fail .

# Format Nix files
format:
    alejandra .

# Check for unused code
deadnix:
    nix run nixpkgs#deadnix -- --fail .

# List NixOS generations
generations:
    nixos-rebuild list-generations

# Show git diff
diff:
    git diff

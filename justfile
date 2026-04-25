# Default recipe - list available commands
default:
    @just --list

# Rebuild the NixOS system (This also rebuilds Home Manager when used as a module)
switch:
    @echo "Rebuilding NixOS system..."
    sudo nixos-rebuild switch --flake .#Melek

# Rebuild Home Manager configuration standalone (Only needed if NOT using the NixOS module)
home-switch:
    @echo "Rebuilding Home Manager..."
    home-manager switch --flake .#melek

# Update flake inputs and rebuild both System and Home Manager
update:
    @echo "Updating flake inputs..."
    nix flake update
    @echo "Rebuilding System..."
    sudo nixos-rebuild switch --flake .#Melek

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

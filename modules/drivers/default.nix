{...}: {
  imports = [
    ./amd-drivers.nix
    ./intel-drivers.nix
    ./local-hardware-clock.nix
    ./nvidia-drivers.nix
    ./nvidia-prime-drivers.nix
    ./amd-nvidia.nix
    ./vm-guest-services.nix
  ];
}

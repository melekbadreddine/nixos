{...}: {
  imports = [
    ./amd-drivers.nix
    ./intel-drivers.nix
    ./nvidia-drivers.nix
    ./nvidia-prime-drivers.nix
    ./amd-nvidia.nix
    ./vm-guest-services.nix
  ];
}

{host, inputs, lib, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../hosts/${host}
    ../../modules/drivers
  ];

  wsl = {
    enable = true;
    defaultUser = "melek";
    startMenuLaunchers = true;
    
    # Enable integration with Windows
    interop.register = true;
  };

  # Disable hardware-specific drivers not needed for WSL
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;

  # Disable SDDM as WSL handles the session startup
  services.displayManager.sddm.enable = lib.mkForce false;
}

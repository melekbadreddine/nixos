{host, ...}: {
  imports = [
    ../../hosts/${host}
  ];

  wsl = {
    enable = true;
    defaultUser = "melek";
    startMenuLaunchers = true;
    
    # Enable integration with Windows
    interop.enable = true;
  };

  # Disable hardware-specific drivers not needed for WSL
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;

  # Plasma 6 works in WSL via WSLg, but you might want to disable 
  # SDDM as WSL handles the "session" startup differently.
  services.displayManager.sddm.enable = false;
}

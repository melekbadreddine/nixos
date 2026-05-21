{vars, ...}: {
  imports = [
    ../../hosts/default
    ../../modules/drivers
  ];

  # Enable AMD+NVIDIA hybrid drivers (Prime offload with AMD as primary)
  drivers.amd-nvidia = {
    enable = true;
    amdBusId = vars.amdgpuID;
    nvidiaBusId = vars.nvidiaID;
  };

  # Ensure other driver toggles are off for this profile
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;

  vm.guest-services.enable = false;
}

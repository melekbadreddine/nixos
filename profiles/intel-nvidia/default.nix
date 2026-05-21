{vars, ...}: {
  imports = [
    ../../hosts/default
    ../../modules/drivers
  ];
  # Enable GPU Drivers
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    intelBusId = vars.intelID;
    nvidiaBusId = vars.nvidiaID;
  };
  drivers.intel.enable = false;
  drivers.amd-nvidia.enable = false;
  vm.guest-services.enable = false;
}

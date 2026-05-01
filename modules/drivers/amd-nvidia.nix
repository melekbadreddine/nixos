{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.drivers.amd-nvidia;
in {
  options.drivers.amd-nvidia = {
    enable = mkEnableOption "Enable AMD iGPU + NVIDIA dGPU (Prime offload)";
    # AMD iGPU Bus ID (e.g., PCI:5:0:0). Expose as option for future host wiring.
    amdBusId = mkOption {
      type = types.str;
      default = "PCI:5:0:0";
      description = "PCI Bus ID for AMD iGPU";
    };
    # NVIDIA dGPU Bus ID (e.g., PCI:1:0:0)
    nvidiaBusId = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
      description = "PCI Bus ID for NVIDIA dGPU";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      # RTX 50xx and modern architectures benefit from the open-source kernel module.
      # This enables advanced power management and is the path forward for NVIDIA on Linux.
      open = true; 
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Helpful on laptops to power down the dGPU when idle (requires Turing or newer)
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      # AMD primary, NVIDIA offload
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Wire from options
        amdBusId = cfg.amdBusId;
        nvidiaBusId = cfg.nvidiaBusId;
      };
    };
  };
}

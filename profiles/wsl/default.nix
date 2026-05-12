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

  # WSL does not use a standard bootloader
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.plymouth.enable = lib.mkForce false;
  boot.kernelParams = lib.mkForce [];
  boot.consoleLogLevel = lib.mkForce 3;
  boot.initrd.verbose = lib.mkForce true;
}

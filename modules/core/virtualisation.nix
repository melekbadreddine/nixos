{
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
    # Only enable either docker or podman -- Not both
    docker = {
      enable = true;
      /*
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      */
    };

    podman.enable = false;

    libvirtd = {
      enable = true;
      onBoot = "ignore"; # Saves RAM; starts when you open virt-manager
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true; # Required for Windows 11 / Secure Boot VMs
      };
    };

    # Kernel modules for better VM performance
    # spiceUSBRedirection.enable = true;
  };

  /*
  # Enable OpenGL support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  */

  # k3s lightweight Kubernetes
  # Note: Disabled by default at boot. Enable manually if needed for development.
  # This prevents unnecessary resource consumption on systems that don't actively use Kubernetes.
  services.k3s.enable = true;
  systemd.services.k3s.wantedBy = lib.mkForce [];

  programs.virt-manager.enable = true;

  # Recommended additions for a better UI experience
  environment.systemPackages = with pkgs; [
    lazydocker
    virt-viewer # Better performance than the built-in virt-manager viewer
    spice-gtk # Needed for clipboard sharing between host and VM
    kubernetes-helm
    k9s
  ];
}

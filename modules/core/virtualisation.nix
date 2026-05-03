{lib, ...}: {
  # Docker rootless mode for better security
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # QEMU/KVM virtualization with virt-manager UI
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  programs.virt-manager.enable = true;

  # k3s lightweight Kubernetes
  # Note: Disabled by default at boot. Enable manually if needed for development.
  # This prevents unnecessary resource consumption on systems that don't actively use Kubernetes.
  services.k3s.enable = true;
  systemd.services.k3s.wantedBy = lib.mkForce [];
}

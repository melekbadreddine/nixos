{config, ...}: {
  # Force oci-containers to use Docker instead of defaulting to Podman
  virtualisation.oci-containers.backend = "docker";

  # Spins up the background translating daemon engine
  virtualisation.oci-containers.containers."litellm-nim" = {
    image = "docker.litellm.ai/berriai/litellm:main-stable";
    ports = ["4000:4000"];
    volumes = [
      # Standardizing configuration link boundaries
      "/home/melek/.config/litellm/config.yaml:/app/config.yaml"
    ];
    cmd = ["--config" "/app/config.yaml"];

    # Securely forwards the sops decrypted environment block
    environmentFiles = [
      config.sops.secrets."NVIDIA_NIM_API_KEY".path
    ];
    autoStart = true;
  };
}

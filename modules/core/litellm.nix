{config, ...}: {
  virtualisation.oci-containers.backend = "docker";

  sops.templates."litellm.env".content = ''
    NVIDIA_NIM_API_KEY=${config.sops.placeholder.NVIDIA_NIM_API_KEY}
  '';

  virtualisation.oci-containers.containers."litellm-nim" = {
    image = "docker.litellm.ai/berriai/litellm:main-stable";

    ports = ["4000:4000"];

    volumes = [
      "/home/melek/.config/litellm/config.yaml:/app/config.yaml"
    ];

    cmd = ["--config" "/app/config.yaml"];

    environmentFiles = [
      config.sops.templates."litellm.env".path
    ];

    autoStart = true;
  };
}

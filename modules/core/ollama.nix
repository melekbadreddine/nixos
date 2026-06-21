{
  pkgs,
  profile,
  ...
}: let
  nvidiaProfiles = [
    "nvidia"
    "intel-nvidia"
    "amd-nvidia"
  ];

  useCuda = builtins.elem profile nvidiaProfiles;
in {
  services.ollama = {
    enable = true;
    package =
      if useCuda
      then pkgs.ollama-cuda
      else pkgs.ollama-cpu;

    loadModels = [
      "qwen2.5-coder:7b"
      "gemma4:e4b"
    ];
  };
}

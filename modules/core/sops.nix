{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Path to the encrypted secrets file
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Path to the age key file on the host
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = {
      "GITHUB_TOKEN" = {
        owner = config.users.users.melek.name;
        mode = "0400";
      };
      "GITLAB_TOKEN" = {
        owner = config.users.users.melek.name;
        mode = "0400";
      };
      "DOCKER_TOKEN" = {
        owner = config.users.users.melek.name;
        mode = "0400";
      };
      "NVIDIA_NIM_API_KEY" = {
        # Keeps it secure for systemic/container invocation tasks
        mode = "0400";
      };
    };
  };
}

{ inputs, config, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Path to the encrypted secrets file
    defaultSopsFile = ../../secrets/secrets.yaml;
    
    # Path to the age key file on the host
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."github/token" = {
      owner = config.users.users.melek.name;
      mode = "0400";
    };
  };
}

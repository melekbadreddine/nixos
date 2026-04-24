{ pkgs, ... }: {
  home.packages = with pkgs; [
    ansible
    azure-cli
    terraform
    terraform-ls
    tflint
  ];
}

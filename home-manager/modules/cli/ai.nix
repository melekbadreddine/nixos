{ pkgs, ... }: {
  home.packages = with pkgs; [
    gemini-cli
    github-copilot-cli
  ];
}

{pkgs, ...}: {
  # Enable fish shell at the system level
  programs.fish.enable = true;

  # Add fish to environment shells
  environment.shells = with pkgs; [fish];
}

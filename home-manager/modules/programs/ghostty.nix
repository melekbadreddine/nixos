{ pkgs, ... }: {
  # If programs.ghostty.enable is not yet in your home-manager version, 
  # we use home.packages as a fallback.
  home.packages = [ pkgs.ghostty ];
  
  # programs.ghostty = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   settings = {
  #     theme = "dark";
  #     font-size = 15;
  #   };
  # };
}

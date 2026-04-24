{ ... }: {
  programs.zellij = {
    enable = true;
    # enableBashIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "compact";
      pane_frames = false;
    };
  };
}

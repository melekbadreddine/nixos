{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 11;
    };
    settings = {
      background_opacity = "0.95";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };
}

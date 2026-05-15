{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrains Mono Nerd Font";
      font-size = 11;
      background-opacity = 0.95;
      scrollback-limit = 10000;
      audible-bell = false;
    };
  };
}

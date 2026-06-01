{...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    historyLimit = 50000;
    baseIndex = 1;
    escapeTime = 0;

    extraConfig = ''
      set -g renumber-windows on
      set -g status-position top
      set -g status-style bg=default
      set -g status-left '#[bold] #S '
      set -g status-right ' %H:%M '
      set -g status-interval 5

      setw -g pane-base-index 1
      setw -g mode-keys vi
    '';
  };
}

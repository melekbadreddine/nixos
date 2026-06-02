{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    historyLimit = 50000;
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_status_background "default"

          # Window/Tab styling at the top
          set -g @catppuccin_window_current_fill "all"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_window_default_fill "none"
          set -g @catppuccin_window_default_text " #W"
        '';
      }
    ];

    extraConfig = ''
      # -------------------------------------------------------------
      # 1. TOP BAR: Global Status (Handles Tabs/Windows)
      # -------------------------------------------------------------
      set -g status-position top
      set -g renumber-windows on
      set -g status-interval 1

      # Clean up the top bar headers to only focus on Tabs/Windows
      set -g status-left "#[bg=#a6e3a1,fg=#11111b,bold] TMUX #[bg=default,fg=default] "
      set -g status-right "#[bg=#313244,fg=#cdd6f4] 󱫋 #S " # Just shows session name on the top right

      # -------------------------------------------------------------
      # 2. BOTTOM BAR: Shortcut Cheat Sheet
      # -------------------------------------------------------------
      # Tmux workaround for a permanent bottom bar: Use the pane-border status system!
      set -g pane-border-status bottom

      # Hide the default ugly line and format our custom command layout
      set -g pane-border-format "#[align=left]#[fg=#6c7086]─#[bg=#313244,fg=#cdd6f4,bold] Ctrl+a 🠚 #[bg=#45475a,fg=#f38ba8] <p> PANE #[bg=#45475a,fg=#a6e3a1] <w> WINDOW #[bg=#45475a,fg=#89b4fa] <s> SESSION #[bg=#45475a,fg=#f9e2af] <r> RESIZE #[bg=#45475a,fg=#cba6f7] <q> QUIT #[bg=default,fg=#6c7086]────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────"

      # Make the active/inactive pane borders invisible so only the text stands out
      set -g pane-border-style "fg=#313244"
      set -g pane-active-border-style "fg=#313244"

      # -------------------------------------------------------------
      # 3. Keybindings
      # -------------------------------------------------------------
      set -g prefix Ctrl-a
      unbind Ctrl-b
      bind Ctrl-a send-prefix

      # Pane Management (<p> Pane)
      bind p split-window -h -c "#{pane_current_path}"
      bind v split-window -v -c "#{pane_current_path}"

      # Window Management (<w> Tab/Window)
      bind w new-window -c "#{pane_current_path}"

      # Fast layout navigation (Alt + hjkl)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -u
      bind -n M-l select-pane -R
    '';
  };
}

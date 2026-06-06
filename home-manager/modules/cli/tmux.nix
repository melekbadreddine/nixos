{
  pkgs,
  lib,
  config,
  ...
}: let
  base16 = config.lib.stylix.colors;
in {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    prefix = "M-d";
    terminal = "tmux-256color";
    tmuxp.enable = false;
    shell = "${pkgs.fish}/bin/fish";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      sessionist
      open
      tmux-fzf
      {
        plugin = catppuccin;
        extraConfig =
          #sh
          ''
            set -g @catppuccin_date_time_color "${base16.base0B}"
            set -g @catppuccin_date_time_text "%H:%M"
            set -g @catppuccin_directory_color "${base16.base0C}"
            set -g @catppuccin_directory_text "#{b:pane_current_path}"
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_pane_active_border_style "fg=${base16.base0C}"
            set -g @catppuccin_session_color "${base16.base0C}"
            set -g @catppuccin_status_connect_separator "no"
            set -g @catppuccin_status_fill "all"
            set -g @catppuccin_status_left_separator "█"
            set -g @catppuccin_status_modules_left "session"
            set -g @catppuccin_status_modules_right "directory date_time"
            set -g @catppuccin_status_right_separator "█"
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_window_current_background "${base16.base00}"
            set -g @catppuccin_window_current_color "${base16.base0C}"
            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
            set -g @catppuccin_window_default_background "${base16.base00}"
            set -g @catppuccin_window_default_color "${base16.base04}"
            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_left_separator "█"
            set -g @catppuccin_window_middle_separator "  █"
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_right_separator "█ "
          '';
      }
      {
        plugin = session-wizard;
        extraConfig = ''
          set -g @session-wizard 't'
          set -g @session-wizard-height 40
          set -g @session-wizard-width 80
        '';
      }
      tmux-thumbs
    ];

    extraConfig =
      #sh
      ''
              set -ag terminal-overrides ",xterm-256color:RGB"
              set-option -g allow-passthrough
              set -g status-position top
              set -g pane-border-lines heavy

              set-option -g set-titles on
              set-option -g set-titles-string '#S: #W - TMUX'

              # =====================================================================
              # BOTTOM CHEATSHEET
              # =====================================================================
              set -g status 2

              set -g status-format[1] "#[fg=${base16.base05},bg=${base16.base01}] \
        #[fg=${base16.base0E},bold]Alt+d#[fg=${base16.base05},none] Prefix \
        #[fg=${base16.base01},bg=${base16.base03}]#[fg=${base16.base05},bg=${base16.base03}] \
        #[fg=${base16.base0A},bold]) / =#[fg=${base16.base05},none] Split \
        #[fg=${base16.base03},bg=${base16.base01}]#[fg=${base16.base05},bg=${base16.base01}] \
        #[fg=${base16.base0D},bold]Alt+Shift+H/L#[fg=${base16.base05},none] Cycle Tabs \
        #[fg=${base16.base01},bg=${base16.base03}]#[fg=${base16.base05},bg=${base16.base03}] \
        #[fg=${base16.base0B},bold]Ctrl+h/j/k/l#[fg=${base16.base05},none] Navigate \
        #[fg=${base16.base03},bg=${base16.base01}]#[fg=${base16.base05},bg=${base16.base01}] \
        #[fg=${base16.base0C},bold]Prefix+v#[fg=${base16.base05},none] Copy Mode \
        #[fg=${base16.base01},bg=${base16.base00}] \
        #[fg=${base16.base04},italics](AZERTY Mapped)#[fill=${base16.base01}]"
              # =====================================================================

              bind v copy-mode
              bind R source-file ~/.config/tmux/tmux.conf

              # Standard Fallbacks
              bind '"' split-window -v -c "#{pane_current_path}"
              bind % split-window -h -c "#{pane_current_path}"
              bind '-' split-window -v -c "#{pane_current_path}"
              bind '|' split-window -h -c "#{pane_current_path}"

              # Ergonomic Unshifted AZERTY Splits
              bind ) split-window -h -c "#{pane_current_path}"
              bind = split-window -v -c "#{pane_current_path}"

              # Fast Window Cycling
              bind -n M-H previous-window
              bind -n M-L next-window

              # AZERTY Native Unshifted Window Selections
              bind-key & select-window -t 1
              bind-key é select-window -t 2
              bind-key '"' select-window -t 3
              bind-key ' select-window -t 4
              bind-key ( select-window -t 5
              bind-key - select-window -t 6
              bind-key è select-window -t 7
              bind-key _ select-window -t 8
              bind-key ç select-window -t 9

              # Selection Mechanics
              bind -T copy-mode-vi v send -X begin-selection
              bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
              bind P paste-buffer
              bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

              bind-key H choose-window "join-pane -h -s "%%""
              bind-key V choose-window "join-pane -v -s "%%""

              # Resize Profiles
              bind-key -r -T prefix       M-k               resize-pane -U 5
              bind-key -r -T prefix       M-j               resize-pane -D 5
              bind-key -r -T prefix       M-h               resize-pane -L 5
              bind-key -r -T prefix       M-l               resize-pane -R 5
              bind-key -r -T prefix       C-Up              resize-pane -U
              bind-key -r -T prefix       C-Down            resize-pane -D
              bind-key -r -T prefix       C-Left            resize-pane -L
              bind-key -r -T prefix       C-Right           resize-pane -R

              # Navigation
              bind-key -T copy-mode-vi 'C-h' select-pane -L
              bind-key -T copy-mode-vi 'C-j' select-pane -D
              bind-key -T copy-mode-vi 'C-k' select-pane -U
              bind-key -T copy-mode-vi 'C-l' select-pane -R
              bind-key -T copy-mode-vi 'C-\' select-pane -l

              set-option -g status-justify absolute-centre
              set-option -g status-keys vi
              set -g status-left-length 150
              set -g status-right-length 150
      '';
  };

  home.shellAliases = {
    t = lib.mkDefault "tmux";
    ta = lib.mkDefault "tmux attach -t";
    tdetach = lib.mkDefault "tmux detach";
    tks = lib.mkDefault "tmux kill-session";
    tls = lib.mkDefault "tmux ls";
    tlc = lib.mkDefault "tmux list-clients";
    tns = lib.mkDefault "tmux new -s";
  };
}

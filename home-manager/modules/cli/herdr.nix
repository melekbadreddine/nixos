{
  pkgs,
  lib,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in {
  home.packages = with pkgs; [herdr];

  xdg.configFile."herdr/config.toml".source = tomlFormat.generate "herdr-config" {
    onboarding = false;

    terminal = {
      default_shell = "${pkgs.fish}/bin/fish";
      shell_mode = "auto";
      new_cwd = "follow";
    };

    theme = {
      name = "catppuccin";
      auto_switch = false;
    };

    ui = {
      agent_panel_sort = "priority";
      sidebar_width = 32;
      sound.enabled = true;
      toast = {
        delivery = "system";
        delay_seconds = 1;
      };
    };

    experimental = {
      reveal_hidden_cursor_for_cjk_ime = true;
      cjk_ime_agents = ["claude" "codex"];
      switch_ascii_input_source_in_prefix = true;
      pane_history = true;
    };

    keys = {
      prefix = "alt+d";

      # Vim-style pane navigation
      focus_pane_left = "ctrl+h";
      focus_pane_down = "ctrl+j";
      focus_pane_up = "ctrl+k";
      focus_pane_right = "ctrl+l";

      command = [
        {
          key = "prefix+&";
          type = "workspace";
          command = "workspace-select 1";
        }
        {
          key = "prefix+é";
          type = "workspace";
          command = "workspace-select 2";
        }
        {
          key = "prefix+\"";
          type = "workspace";
          command = "workspace-select 3";
        }
        {
          key = "prefix+'";
          type = "workspace";
          command = "workspace-select 4";
        }
        {
          key = "prefix+(";
          type = "workspace";
          command = "workspace-select 5";
        }
        {
          key = "prefix+)";
          type = "pane";
          command = "split-horizontal";
        }
        {
          key = "prefix+=";
          type = "pane";
          command = "split-vertical";
        }
        {
          key = "prefix+alt+g";
          type = "pane";
          command = "git status && echo && git log --oneline --graph --all -20 | less -R";
        }
      ];
    };
  };

  home.shellAliases = {
    h = lib.mkDefault "herdr";
    ha = lib.mkDefault "herdr attach";
    hls = lib.mkDefault "herdr list";
    hks = lib.mkDefault "herdr kill";
  };
}

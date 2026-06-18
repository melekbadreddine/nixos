{
  config,
  lib,
  host,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fishPlugins.pisces
  ];

  programs.fish = {
    enable = true;

    shellInit =
      ''
        set -g fish_greeting ""

        # If we are in Ghostty but TERM isn't set correctly, fix it for Yazi and others
        if test "$GHOSTTY_RESOURCES_DIR" != "" -a "$TERM" != "xterm-ghostty"
            set -gx TERM xterm-ghostty
        end
      ''
      + lib.optionalString (host == "wsl") ''
        # Avoid slow terminal capability probing under WSL.
        if not contains no-query-term $fish_features
            set -Ua fish_features no-query-term
        end
      '';

    interactiveShellInit = ''
      fastfetch
      starship init fish | source

      fish_vi_key_bindings

      bind -M insert \ez 'zi; commandline -f repaint'
      bind -M insert \eg 'lazygit; commandline -f repaint'
      bind -M insert \eh backward-char
      bind -M insert \el forward-char
      bind -M insert \ej down-or-search
      bind -M insert \ek up-or-search
    '';

    shellAbbrs = {
      k = "kubectl";
      d = "docker";
      dc = "docker-compose";
      tf = "terraform";
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      ports = "ss -tulanp";
      myip = "curl -s ifconfig.me";

      k3s-start = "sudo systemctl start k3s";
      k3s-stop = "sudo systemctl stop k3s";
      k3s-status = "sudo systemctl status k3s";
      k3s-restart = "sudo systemctl restart k3s";
      k3s-logs = "sudo journalctl -u k3s -f";
    };

    functions = {
      nixw = {
        description = "Format, stage, and rebuild NixOS flake";
        body = ''
          set flake_dir ~/nixos
          cd $flake_dir
          nix fmt .
          git add .
          sudo nixos-rebuild switch --flake .#(cat .current-profile 2>/dev/null || echo "amd") --accept-flake-config
        '';
      };

      yz = {
        description = "Yazi with automatic directory change on exit";
        body = ''
          set tmp (mktemp -t yazi-cwd.XXXXXX)
          yazi $argv --cwd-file=$tmp
          if set cwd (cat -- $tmp); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- $cwd
          end
          rm -f -- $tmp
        '';
      };
    };
  };

  home.sessionVariables = {
    STARSHIP_LOG = "error";
  };

  home.file.".config/fish/themes/stylix.theme".text = ''
    fish_color_normal ${config.lib.stylix.colors.base05}
    fish_color_command ${config.lib.stylix.colors.base0D}
    fish_color_keyword ${config.lib.stylix.colors.base0E}
    fish_color_quote ${config.lib.stylix.colors.base0B}
    fish_color_redirection ${config.lib.stylix.colors.base0C}
    fish_color_end ${config.lib.stylix.colors.base0C}
    fish_color_error ${config.lib.stylix.colors.base08}
    fish_color_param ${config.lib.stylix.colors.base05}
    fish_color_comment ${config.lib.stylix.colors.base03}
    fish_color_selection --background=${config.lib.stylix.colors.base02}
    fish_color_search_match --background=${config.lib.stylix.colors.base02}
    fish_color_operator ${config.lib.stylix.colors.base09}
    fish_color_escape ${config.lib.stylix.colors.base0F}
    fish_color_autosuggestion ${config.lib.stylix.colors.base03}
    fish_pager_color_progress ${config.lib.stylix.colors.base03}
    fish_pager_color_prefix ${config.lib.stylix.colors.base0D}
    fish_pager_color_completion ${config.lib.stylix.colors.base05}
    fish_pager_color_description ${config.lib.stylix.colors.base03}
  '';
}

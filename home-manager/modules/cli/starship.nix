{lib, ...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "$os"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$bun"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "$typescript"
        "$lua"
        "$docker_context"
        "$kubernetes"
        "$terraform"
        "[](fg:#212736 bg:#1d2230)"
        "$time"
        "[ ](fg:#1d2230)"
        "$line_break"
        "$character"
      ];

      os = {
        disabled = false;
        style = "bg:#a3aed2 fg:#090c0c";
        symbols = {
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Fedora = "󰣛";
          Gentoo = "󰣨";
          Linux = "󰌽";
          Macos = "";
          Manjaro = "";
          Mint = "󰣭";
          NixOS = "󱄅";
          Pop = " ";
          Raspbian = "󰐿";
          RedHatEnterprise = "󱄛";
          Redhat = "󱄛";
          SUSE = "";
          Ubuntu = "󰕈";
          Windows = "󰍲";
        };
      };

      username.disabled = true;

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        home_symbol = " ~";

        truncation_length = 3;
        truncation_symbol = " …/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        conflicted = "=";
        ahead = "↑\${count}";
        behind = "↓\${count}";
        diverged = "↕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+\${count}";
        deleted = "✘";
      };

      package.symbol = "📦 ";

      bun = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      c = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      docker_context = {
        symbol = "󰡨";
        style = "bg:#394260";
        format = "[[ $symbol( $context) ](fg:#769ff0 bg:#394260)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      java = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      
      kubernetes = {
        symbol = "󱃾";
        style = "bg:#212736";
        format = "[[ $symbol( $context)( \\($namespace\\)) ](fg:#769ff0 bg:#212736)]($style)";
      };

      lua = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      
      terraform = {
        symbol = "󱁢";
        style = "bg:#212736";
        format = "[[ $symbol( $workspace) ](fg:#769ff0 bg:#212736)]($style)";
      };

      typescript = {
        symbol = "󰛦";
        style = "bg:#212736";
        format = "[[ $symbol( $version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:#769ff0)";
        error_symbol = "[❯](bold fg:#f7768e)";
        vimcmd_symbol = "[❮](bold fg:#9ece6a)";
        vimcmd_replace_one_symbol = "[❮](bold fg:#bb9af7)";
        vimcmd_replace_symbol = "[❮](bold fg:#bb9af7)";
        vimcmd_visual_symbol = "[❮](bold fg:#e0af68)";
      };
    };
  };
}

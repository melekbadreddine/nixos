{ lib, ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = lib.concatStrings [
        "[](surface0)"
        "$os"
        "$username"
        "[](bg:peach fg:surface0)"
        "$directory"
        "[](fg:peach bg:green)"
        "$git_branch"
        "$git_status"
        "[](fg:green bg:yellow)"
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
        "[](fg:yellow bg:blue)"
        "$docker_context"
        "[](fg:blue bg:purple)"
        "$time"
        "[ ](fg:purple)"
        "$line_break"
        "$character"
      ];

      palette = lib.mkForce "catppuccin_mocha";

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        orange = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#fcf393";
        green = "#7df9aa";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#1c3a5e";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };

      os = {
        disabled = false;
        style = "bg:surface0 fg:text";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Pop = " ";
          Macos = "";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:surface0 fg:text";
        style_root = "bg:surface0 fg:text";
        format = "[ $user ]($style)";
      };

      directory = {
        style = "fg:mantle bg:peach";
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
        style = "bg:green fg:base bold";
        format = "[ $symbol $branch]($style)";
      };

      git_status = {
        style = "bg:green fg:base bold";
        format = "([ $all_status$ahead_behind]($style))";
        conflicted = "🏳 ";
        ahead = "🏎💨 ";
        behind = "😰 ";
        diverged = "😵 ";
        untracked = "🤷 ";
        stashed = "󰏗 ";
        modified = "📝 ";
        staged = "[++\($count\)](fg:base bg:green)";
        deleted = "🗑 ";
      };

      package.symbol = "📦 ";

      nodejs = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      bun = {
        symbol = "󰛦 ";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:teal";
        format = "[[ $symbol( $version) ](fg:base bg:yellow)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:mantle";
        format = "[[ $symbol( $context) ](fg:#83a598 bg:surface2)]($style)"; # Note: surface2 used as fallback for color_bg3
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:peach";
        format = "[[  $time ](fg:mantle bg:purple)]($style)";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[](bold fg:green)";
        error_symbol = "[](bold fg:red)";
        vimcmd_symbol = "[](bold fg:green)";
        vimcmd_replace_one_symbol = "[](bold fg:purple)";
        vimcmd_replace_symbol = "[](bold fg:purple)";
        vimcmd_visual_symbol = "[](bold fg:lavender)";
      };
    };
  };
}

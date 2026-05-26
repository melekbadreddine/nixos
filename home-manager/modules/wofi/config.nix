{config, ...}: let
  colors = config.lib.stylix.colors;
in {
  programs.wofi.settings = {
    width = 600;
    height = 400;
    no_actions = true;
    insensitive = true;
    location = "center";
  };

  programs.wofi.style = ''
    window {
        margin: 0px;
        padding: 0px;
        border: none;
        background-color: transparent;
        font-family: "DepartureMono Nerd Font", monospace;
        font-size: 14px;
    }

    #outer-box {
        margin: 0px;
        padding: 6px;
        border: 2px solid #${colors.base02};
        border-radius: 8px;
        background-color: #${colors.base00}f2;
    }

    #input {
        margin: 0px 0px 8px 0px;
        padding: 10px 16px;
        border: 2px solid #${colors.base01}cc;
        border-radius: 6px;
        color: #${colors.base05};
        background-color: #${colors.base01}99;
    }

    #input:focus {
        background-color: #${colors.base01}cc;
        border-color: #${colors.base0B};
    }

    #text {
        margin: 0px;
        border: none;
        color: #${colors.base05};
        padding: 6px 12px;
    }

    #entry:selected {
        background-color: #${colors.base0B}4d;
        border-radius: 6px;
    }

    #entry:selected #text {
        color: #${colors.base0B};
        font-weight: bold;
    }
  '';
}

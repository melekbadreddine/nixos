{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: white;
      }

      #waybar > box {
        margin: 5px 10px;
        background: rgba(40, 42, 54, 0.8);
        border-radius: 15px;
        border: 2px solid rgba(255, 255, 255, 0.1);
      }

      .modules-left, .modules-center, .modules-right {
        background: rgba(30, 30, 46, 0.8);
        border-radius: 15px;
        padding: 2px 10px;
        margin: 5px;
      }

      #workspaces button {
        padding: 0 5px;
        color: #cdd6f4;
      }

      #workspaces button.active {
        color: #fab387;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
      }
    '';
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      margin-top = 5;
      margin-left = 10;
      margin-right = 10;
      modules-left = [ "clock" "cpu" "memory" ];
      modules-center = [ "workspaces" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];

      "clock" = {
        format = "{:%H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      "cpu" = {
        format = "  {usage}%";
      };
      "memory" = {
        format = "  {}%";
      };
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "";
        format-icons = {
          default = [ "" "" "" ];
        };
      };
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };
    }];
  };
}

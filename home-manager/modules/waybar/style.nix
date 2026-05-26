{...}: {
  programs.waybar.style = ''
    @import "colors.css";

    * {
        font-family: "DepartureMono Nerd Font", "Font Awesome 6 Free", monospace;
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
    }

    #waybar {
        background-color: alpha(@bg, 0.85);
        color: @fg;
        border-radius: 8px;
        padding: 4px 8px;
    }

    .modules-left,
    .modules-center,
    .modules-right {
        padding: 0 4px;
    }

    #custom-nixos,
    #tags,
    #window,
    #cpu,
    #temperature,
    #memory,
    #disk,
    #network,
    #tray,
    #custom-notifications,
    #battery,
    #pulseaudio,
    #clock,
    #custom-power {
        padding: 4px 10px;
        margin: 2px 3px;
        border-radius: 8px;
        background-color: transparent;
    }

    #tags button {
        padding: 2px 7px;
        margin: 0 2px;
        color: @outline;
        background-color: transparent;
        border-radius: 6px;
        transition: all 0.2s ease;
    }

    #tags button.occupied {
        color: @warning;
    }

    #tags button.focused,
    #tags button.active {
        color: @bg;
        background-color: @accent;
        font-weight: bold;
    }

    #tags button.urgent {
        color: @error;
        background-color: alpha(@error, 0.2);
    }

    #tags button:hover {
        background-color: alpha(@accent, 0.3);
        color: @fg;
    }

    #cpu { color: @error; }
    #temperature { color: @secondary; }
    #memory { color: @warning; }
    #disk { color: @accent; }
    #network { color: @tertiary; }
    #custom-notifications { color: @tertiary; }
    #battery { color: @tertiary; }
    #pulseaudio { color: @secondary; }
    #custom-power { color: @error; }

    tooltip {
        background-color: alpha(@bg, 0.95);
        border: 1px solid alpha(@outline, 0.8);
        border-radius: 8px;
        padding: 8px;
    }

    tooltip label {
        color: @fg;
        padding: 4px;
    }
  '';
}

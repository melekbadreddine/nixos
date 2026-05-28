{...}: {
  programs.waybar.style = ''
    /* ─── Waybar Verbatim Template ─── */
    @import "colors.css";

    * {
        font-family:
            "JetBrainsMono Nerd Font", "JetBrains Mono", "Font Awesome 6 Free",
            monospace;
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
    }

    /* ─── Main Bar ─── */
    #waybar {
        background-color: alpha(@bg, 0.85);
        color: @fg;
        border-radius: 8px;
        padding: 4px 8px;
    }

    /* ─── Module Sections ─── */
    .modules-left,
    .modules-center,
    .modules-right {
        padding: 0 4px;
    }

    /* ─── Individual Modules ─── */
    #image,
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
    #custom-power,
    #custom-power#vertical {
        padding: 4px 10px;
        margin: 2px 3px;
        border-radius: 8px;
        background-color: transparent;
    }

    /* ─── NixOS Logo (Image) ─── */
    #image,
    #image#nixos {
        padding: 4px 8px;
        margin: 2px 3px;
        border-radius: 8px;
        background-color: transparent;
    }

    /* ─── Workspaces (dwl/tags) ─── */
    #tags,
    #tags#vertical {
        background-color: transparent;
        padding: 2px 6px;
    }

    #tags button,
    #tags#vertical button {
        padding: 2px 7px;
        margin: 0 2px;
        color: @outline;
        background-color: transparent;
        border-radius: 6px;
        transition: all 0.2s ease;
    }

    /* Occupied workspace */
    #tags button.occupied,
    #tags#vertical button.occupied {
        color: @warning;
    }

    /* Empty workspace */
    #tags button.empty,
    #tags#vertical button.empty {
        color: @outline;
    }

    /* Focused workspace */
    #tags button.focused,
    #tags button.active,
    #tags#vertical button.focused,
    #tags#vertical button.active {
        color: @bg;
        background-color: @accent;
        font-weight: bold;
    }

    /* Urgent workspace */
    #tags button.urgent,
    #tags#vertical button.urgent {
        color: @error;
        background-color: alpha(@error, 0.2);
    }

    /* Hover effect */
    #tags button:hover,
    #tags#vertical button:hover {
        background-color: alpha(@accent, 0.3);
        color: @fg;
    }

    #tags button.focused:hover,
    #tags button.active:hover,
    #tags#vertical button.focused:hover,
    #tags#vertical button.active:hover {
        background-color: @accent;
        color: @bg;
    }

    /* ─── Active Window (dwl/window) ─── */
    #window {
        color: @fg;
        background-color: transparent;
    }

    /* ─── Center System Stats ─── */
    #cpu {
        color: @error;
    }

    #temperature {
        color: @secondary;
    }

    #temperature.critical {
        color: @error;
        background-color: alpha(@error, 0.2);
    }

    #memory {
        color: @warning;
    }

    #disk {
        color: @accent;
    }

    #network {
        color: @tertiary;
    }

    #network.disconnected {
        color: @outline;
    }

    /* ─── System Tray ─── */
    #tray {
        background-color: transparent;
        padding: 4px 8px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: alpha(@secondary, 0.3);
    }

    /* ─── Notifications ─── */
    #custom-notifications {
        color: @tertiary;
    }

    #custom-notifications.has-notifications {
        color: @error;
    }

    /* ─── Battery ─── */
    #battery {
        color: @tertiary;
    }

    #battery.warning {
        color: @warning;
    }

    #battery.critical {
        color: @error;
    }

    #battery.charging,
    #battery.plugged {
        color: @accent;
    }

    /* ─── Pulseaudio ─── */
    #pulseaudio {
        color: @secondary;
    }

    #pulseaudio.muted {
        color: @outline;
    }

    /* ─── Clock ─── */
    #clock,
    #clock#vertical {
        color: @fg;
        background-color: transparent;
        font-weight: 600;
    }

    /* ─── Power Button ─── */
    #custom-power,
    #custom-power#vertical {
        color: @error;
        background-color: transparent;
        font-size: 14px;
        padding: 2px 12px;
    }

    #custom-power:hover,
    #custom-power#vertical:hover {
        background-color: alpha(@error, 0.15);
    }

    /* ─── Tooltip ─── */
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

{
  lib,
  pkgs,
  ...
}: {
  # ===== HOME-MANAGER CONFIGURATION =====

  # Tofi application launcher
  programs.tofi = {
    enable = true;
    settings = {
      history = false;
      prompt-text = ''" "'';
      hide-cursor = true;
      drun-launch = true;
    };
  };

  # Waybar status bar
  programs.waybar = {
    enable = true;
    settings.bar = {
      layer = "top";
      position = "top";

      modules-left = ["ext/workspaces"];
      modules-center = ["clock"];
      modules-right = [
        "network"
        "wireplumber"
      ];

      "ext/workspaces".on-click = "activate";

      clock = {
        format = "{:%d/%m/%Y, %H:%M}h";
        tooltip = false;
      };

      network = with pkgs; {
        format-disconnected = "󰪎 offline";
        format-ethernet = " {ifname}";
        format-wifi = "{icon} {signalStrength}%";
        format-icons = [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        on-click = "${networkmanagerapplet}/bin/nm-connection-editor";
        tooltip = false;
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-icons = [
          ""
          ""
          ""
        ];
        format-muted = " {volume}%";
        tooltip = false;
        scroll-step = 5.0;
        on-click = "${pkgs.lxqt.pavucontrol-qt}/bin/pavucontrol-qt";
        on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
    };
  };

  # Mango window manager configuration
  wayland.windowManager.mango = {
    enable = true;
    settings = {
      # Window effect
      border_radius = 6;
      no_radius_when_single = 0;
      focused_opacity = "1.0";
      unfocused_opacity = "1.0";

      # Animation Configuration
      animations = 1;
      layer_animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_fade_in = 1;
      animation_fade_out = 1;
      tag_animation_direction = 1;
      zoom_initial_ratio = "0.3";
      zoom_end_ratio = "0.8";
      fadein_begin_opacity = "0.5";
      fadeout_begin_opacity = "0.8";
      animation_duration_move = 500;
      animation_duration_open = 400;
      animation_duration_tag = 350;
      animation_duration_close = 800;
      animation_duration_focus = 0;
      animation_curve_open = "0.46,1.0,0.29,1";
      animation_curve_move = "0.46,1.0,0.29,1";
      animation_curve_tag = "0.46,1.0,0.29,1";
      animation_curve_close = "0.08,0.92,0,1";
      animation_curve_focus = "0.46,1.0,0.29,1";

      # Master-Stack Layout Setting
      new_is_master = 1;
      default_mfact = "0.55";
      default_nmaster = 1;
      smartgaps = 0;

      # Overview Setting
      enable_hotarea = 0;
      ov_tab_mode = 0;
      overviewgappi = 5;
      overviewgappo = 30;

      # Misc
      no_border_when_single = 1;
      axis_bind_apply_timeout = 100;
      focus_on_activate = 1;
      sloppyfocus = 1;
      warpcursor = 0;
      focus_cross_monitor = 0;
      focus_cross_tag = 0;
      enable_floating_snap = 0;
      snap_distance = 30;
      drag_tile_to_tile = 1;

      # Keyboard
      repeat_rate = 25;
      repeat_delay = 600;
      numlockon = 0;
      xkb_rules_layout = "fr";

      # Mouse
      mouse_natural_scrolling = 0;

      # Appearance
      gappih = 5;
      gappiv = 5;
      gappoh = 10;
      gappov = 10;
      scratchpad_width_ratio = "0.8";
      scratchpad_height_ratio = "0.9";
      borderpx = 4;
      rootcolor = "0x201b14ff";
      bordercolor = "0x444444ff";
      focuscolor = "0xc9b890ff";
      maximizescreencolor = "0x89aa61ff";
      urgentcolor = "0xad401fff";
      scratchpadcolor = "0x516c93ff";
      globalcolor = "0xb153a7ff";
      overlaycolor = "0x14a57cff";

      # Layouts
      tagrule = [
        "id:1,layout_name:tile"
        "id:2,layout_name:tile"
        "id:3,layout_name:tile"
        "id:4,layout_name:tile"
        "id:5,layout_name:tile"
        "id:6,layout_name:tile"
        "id:7,layout_name:tile"
        "id:8,layout_name:tile"
        "id:9,layout_name:tile"
      ];

      # Keybindings
      bind = [
        # launchers
        "SUPER,w,spawn,${pkgs.tofi}/bin/tofi-drun"
        "SUPER,t,spawn,${pkgs.alacritty}/bin/alacritty"
        "none,Print,spawn,${pkgs.wayshot}/bin/wayshot -c -e jpg"

        # power
        "SUPER+Shift,u,spawn,${pkgs.systemd}/bin/systemctl poweroff"
        "SUPER+Shift,r,spawn,${pkgs.systemd}/bin/systemctl reboot"

        # exit
        "ctrl+alt,space,quit"
        "SUPER,q,killclient,"

        # switch window focus
        "SUPER,h,focusdir,left"
        "SUPER,j,focusdir,down"
        "SUPER,k,focusdir,up"
        "SUPER,l,focusdir,right"

        # swap window
        "SUPER+SHIFT,h,exchange_client,left"
        "SUPER+SHIFT,j,exchange_client,down"
        "SUPER+SHIFT,k,exchange_client,up"
        "SUPER+SHIFT,l,exchange_client,right"

        # switch window status
        "SUPER,f,togglefullscreen,"

        # switch layout
        "SUPER,space,switch_layout"

        # tag switch
        "SUPER,1,view,1,0"
        "SUPER,2,view,2,0"
        "SUPER,3,view,3,0"
        "SUPER,4,view,4,0"
        "SUPER,5,view,5,0"
        "SUPER,6,view,6,0"
        "SUPER,7,view,7,0"
        "SUPER,8,view,8,0"
        "SUPER,9,view,9,0"
        "SUPER,0,toggleoverview"

        # places windows in tags
        "SUPER+shift,1,tag,1,0"
        "SUPER+shift,2,tag,2,0"
        "SUPER+shift,3,tag,3,0"
        "SUPER+shift,4,tag,4,0"
        "SUPER+shift,5,tag,5,0"
        "SUPER+shift,6,tag,6,0"
        "SUPER+shift,7,tag,7,0"
        "SUPER+shift,8,tag,8,0"
        "SUPER+shift,9,tag,9,0"
      ];

      # Mouse bindings
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];

      # Window rules
      windowrule = [
        "isfloating:1,appid:swayimg"
      ];
    };

    # Set required environment variables for Wayland/Mango
    systemd.variables = [
      "XCURSOR_THEME=Bibata-Modern-Ice"
      "XCURSOR_SIZE=24"
    ];

    # Autostart programs
    autostart_sh = ''
      # Ensure HM binaries are in PATH
      export PATH=$PATH:${pkgs.wlsunset}/bin:${pkgs.swaybg}/bin:${pkgs.waybar}/bin

      ${pkgs.wlsunset}/bin/wlsunset -S 5:00 -s 18:00 -T 6500 -t 2800 &
      ${pkgs.swaybg}/bin/swaybg -i ${../../assets/wallpapers/sword.jpg} &
      ${pkgs.waybar}/bin/waybar &
    '';
  };
}

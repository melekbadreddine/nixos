{
  config,
  pkgs,
  vars,
  helium,
  zen-browser,
  mango,
  ...
}: let
  # Helper to convert Stylix color to Mango format (0xRRGGBBAA)
  toMangoColor = color: "0x${color}ff";
  colors = config.lib.stylix.colors;

  # Fallback image if stylix.image is null (can happen in some evaluation contexts)
  wallpaper =
    if config.stylix.image != null
    then config.stylix.image
    else vars.stylixImage;
in {
  imports = [mango.hmModules.mango];

  wayland.windowManager.mango = {
    enable = true;

    extraConfig = ''
      input {
          kb_layout = fr
          kb_variant = azerty
      }
    '';

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

      # Layout
      new_is_master = 1;
      default_mfact = "0.55";
      default_nmaster = 1;
      smartgaps = 0;

      # Appearance (Using Stylix)
      gappih = 5;
      gappiv = 5;
      gappoh = 10;
      gappov = 10;
      borderpx = 4;

      rootcolor = toMangoColor colors.base00;
      bordercolor = toMangoColor colors.base03;
      focuscolor = toMangoColor colors.base0D;
      maximizescreencolor = toMangoColor colors.base0B;
      urgentcolor = toMangoColor colors.base08;
      scratchpadcolor = toMangoColor colors.base0E;
      globalcolor = toMangoColor colors.base07;
      overlaycolor = toMangoColor colors.base0C;

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
        "SUPER,Return,spawn,${pkgs.ghostty}/bin/ghostty"
        "SUPER,h,spawn,${helium.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/helium"
        "SUPER,z,spawn,${zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/zen"
        "SUPER,a,spawn,${pkgs.antigravity}/bin/antigravity"
        "SUPER,w,spawn,${pkgs.warp-terminal}/bin/warp-terminal"
        "SUPER,f,spawn,${pkgs.lxqt.pcmanfm-qt}/bin/pcmanfm-qt"
        "SUPER,Space,spawn,${pkgs.tofi}/bin/tofi-drun"
        "SUPER,q,killclient,"
        "ctrl+alt,space,quit"

        # Focus
        "SUPER,Left,focusdir,left"
        "SUPER,Down,focusdir,down"
        "SUPER,Up,focusdir,up"
        "SUPER,Right,focusdir,right"

        # Move
        "SUPER+SHIFT,Left,exchange_client,left"
        "SUPER+SHIFT,Down,exchange_client,down"
        "SUPER+SHIFT,Up,exchange_client,up"
        "SUPER+SHIFT,Right,exchange_client,right"

        # Tags
        "SUPER,1,view,1,0"
        "SUPER,2,view,2,0"
        "SUPER,3,view,3,0"
        "SUPER,4,view,4,0"
        "SUPER,5,view,5,0"
        "SUPER,6,view,6,0"
        "SUPER,7,view,7,0"
        "SUPER,8,view,8,0"
        "SUPER,9,view,9,0"

        "SUPER+SHIFT,1,tag,1,0"
        "SUPER+SHIFT,2,tag,2,0"
        "SUPER+SHIFT,3,tag,3,0"
        "SUPER+SHIFT,4,tag,4,0"
        "SUPER+SHIFT,5,tag,5,0"
        "SUPER+SHIFT,6,tag,6,0"
        "SUPER+SHIFT,7,tag,7,0"
        "SUPER+SHIFT,8,tag,8,0"
        "SUPER+SHIFT,9,tag,9,0"

        "SUPER,0,toggleoverview"
        "SUPER,f,togglefullscreen,"
        "SUPER,BackSpace,spawn,${pkgs.systemd}/bin/loginctl terminate-user $USER"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
    };

    autostart_sh = ''
      ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill &
      ${pkgs.waybar}/bin/waybar &
    '';
  };

  # Core tools for Mango
  programs.tofi = {
    enable = true;
    settings = {
      history = false;
      prompt-text = " ";
      hide-cursor = true;
      drun-launch = true;
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = ["ext/workspaces"];
      modules-center = ["clock"];
      modules-right = ["network" "wireplumber"];

      "ext/workspaces".on-click = "activate";
      clock = {
        format = "{:%d/%m/%Y, %H:%M}h";
        tooltip = false;
      };
      network = {
        format-disconnected = "󰪎 offline";
        format-ethernet = " {ifname}";
        format-wifi = "{icon} {signalStrength}%";
        format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
        on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };
      wireplumber = {
        format = "{icon} {volume}%";
        format-icons = ["" "" ""];
        format-muted = " {volume}%";
        on-click = "${pkgs.lxqt.pavucontrol-qt}/bin/pavucontrol-qt";
      };
    };
  };

  home.packages = with pkgs; [
    swaybg
    wlsunset
    wayshot
    networkmanagerapplet
    lxqt.pcmanfm-qt
    lxqt.pavucontrol-qt
  ];
}

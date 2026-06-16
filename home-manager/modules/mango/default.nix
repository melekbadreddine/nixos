{
  config,
  pkgs,
  vars,
  helium,
  zen-browser,
  mango,
  noctalia,
  inputs,
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

  noctaliaPkg = noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  noctaliaBin = "${noctaliaPkg}/bin/noctalia";
  rofiBin = "${pkgs.rofi}/bin/rofi";

  codexPkg = let
    cfg = config.programs.codexDesktopLinux;
    flakePackages = inputs.codex-desktop-linux.packages.${pkgs.stdenv.hostPlatform.system};
    packageName =
      if cfg.remoteMobileControl.enable && cfg.computerUseUi.enable
      then "codex-desktop-computer-use-ui-remote-mobile-control"
      else if cfg.remoteMobileControl.enable
      then "codex-desktop-remote-mobile-control"
      else if cfg.computerUseUi.enable
      then "codex-desktop-computer-use-ui"
      else "codex-desktop";
  in
    if cfg.package != null
    then cfg.package
    else flakePackages.${packageName};

  # Compile/Substitute the autostart template script
  autostartScript = pkgs.replaceVars ./scripts/autostart.sh {
    swaybg = "${pkgs.swaybg}/bin/swaybg";
    wallpaper = toString wallpaper;
    noctalia = noctaliaBin;
  };
in {
  imports = [mango.hmModules.mango];

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

      # Layout
      new_is_master = 1;
      default_mfact = "0.55";
      default_nmaster = 1;
      smartgaps = 0;
      xkb_rules_layout = "fr";
      xkb_rules_variant = "oss";
      xkb_rules_model = "pc105";
      xkb_rules_rules = "evdev";

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
        "SUPER,c,spawn,${codexPkg}/bin/codex-desktop"
        "SUPER,a,spawn,${pkgs.antigravity}/bin/antigravity"
        "SUPER,w,spawn,${pkgs.warp-terminal}/bin/warp-terminal"
        "SUPER,f,spawn,${pkgs.lxqt.pcmanfm-qt}/bin/pcmanfm-qt"
        # Rofi launcher (replaces tofi)
        "SUPER,Space,spawn,${rofiBin} -show drun"
        "SUPER,v,spawn,${pkgs.virt-manager}/bin/virt-manager"
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

        # Noctalia IPC — shell panels
        "SUPER,s,spawn,${noctaliaBin} msg panel-toggle control-center"
        "SUPER,comma,spawn,${noctaliaBin} msg settings-toggle"

        # Media keys via Noctalia IPC
        "NONE,XF86AudioRaiseVolume,spawn,${noctaliaBin} msg volume-up"
        "NONE,XF86AudioLowerVolume,spawn,${noctaliaBin} msg volume-down"
        "NONE,XF86AudioMute,spawn,${noctaliaBin} msg volume-mute"
        "NONE,XF86MonBrightnessUp,spawn,${noctaliaBin} msg brightness-up"
        "NONE,XF86MonBrightnessDown,spawn,${noctaliaBin} msg brightness-down"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
    };

    # Run the substituted autostart script
    autostart_sh = "${pkgs.bash}/bin/bash ${autostartScript}";
  };

  home.packages = with pkgs; [
    swaybg
    wlsunset
    wayshot
    networkmanagerapplet
    lxqt.pcmanfm-qt
    lxqt.pavucontrol-qt
    noctaliaPkg
  ];
}

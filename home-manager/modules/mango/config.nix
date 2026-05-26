{...}: {
  home.file.".config/mango/config.conf".text = ''
    # Mango Config - Nix Managed
    blur=1
    blur_layer=0
    blur_optimized=1
    blur_params_num_passes=2
    blur_params_radius=5
    blur_params_noise=0.02
    blur_params_brightness=0.9
    blur_params_contrast=0.9
    blur_params_saturation=1.2

    shadows=1
    layer_shadows=0
    shadow_only_floating=1
    shadows_size=10
    shadows_blur=15
    shadows_position_x=0
    shadows_position_y=0

    border_radius=6
    no_radius_when_single=0
    focused_opacity=0.95
    unfocused_opacity=0.8

    animations=1
    layer_animations=1
    animation_type_open=zoom
    animation_type_close=zoom
    animation_fade_in=1
    animation_fade_out=1
    tag_animation_direction=0
    zoom_initial_ratio=0.4
    zoom_end_ratio=0.8
    fadein_begin_opacity=0.5
    fadeout_begin_opacity=0.8
    animation_duration_move=500
    animation_duration_open=400
    animation_duration_tag=350
    animation_duration_close=100
    animation_duration_focus=0
    animation_curve_open=0.46,1.0,0.29,1
    animation_curve_move=0.46,1.0,0.29,1
    animation_curve_tag=0.46,1.0,0.29,1
    animation_curve_close=0.08,0.92,0,1
    animation_curve_focus=0.46,1.0,0.29,1
    animation_curve_opafadeout=0.5,0.5,0.5,0.5
    animation_curve_opafadein=0.46,1.0,0.29,1

    scroller_structs=450
    scroller_default_proportion=0.5
    scroller_focus_center=0
    scroller_prefer_center=0
    edge_scroller_pointer_focus=0
    scroller_ignore_proportion_single=0
    scroller_default_proportion_single=0.743
    scroller_proportion_preset=0.5,0.7,1.0

    new_is_master=0
    default_mfact=0.5
    default_nmaster=1
    smartgaps=0

    hotarea_size=10
    enable_hotarea=0
    ov_tab_mode=1
    overviewgappi=5
    overviewgappo=50

    no_border_when_single=0
    axis_bind_apply_timeout=100
    focus_on_activate=0
    idleinhibit_ignore_visible=0
    sloppyfocus=1
    warpcursor=1
    focus_cross_monitor=0
    focus_cross_tag=0
    enable_floating_snap=0
    snap_distance=30
    cursor_size=24
    cursor_theme=Macintosh

    repeat_rate=25
    repeat_delay=600
    numlockon=1
    xkb_rules_layout=us

    disable_trackpad=0
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    trackpad_natural_scrolling=0
    disable_while_typing=1
    left_handed=0
    middle_button_emulation=0
    swipe_min_threshold=1

    mouse_natural_scrolling=0

    gappih=5
    gappiv=5
    gappoh=10
    gappov=10
    scratchpad_width_ratio=0.8
    scratchpad_height_ratio=0.9
    borderpx=2

    source=./env.conf
    source=./bind.conf
    source=./monitor.conf
    source=./tag.conf
    source=./rule.conf

    exec-once=mango-autostart

    source = ~/.config/mango/theme-colors.conf
  '';

  home.file.".config/mango/env.conf".text = ''
    env=QT_QPA_PLATFORMTHEME,gtk3
    env=XCURSOR_THEME,Macintosh
    env=XCURSOR_SIZE,24
    env=XDG_CURRENT_DESKTOP,mango
    env=XDG_SESSION_TYPE,wayland
  '';

  home.file.".config/mango/bind.conf".text = ''
    # Mango Keybinds - Nix Managed

    bind=SUPER+ALT,r,spawn,mango-reload
    bind=SUPER,m,quit
    bind=SUPER,q,killclient,
    bind=SUPER+SHIFT,q,spawn,wlogout

    bind=SUPER+SHIFT,t,spawn,switch-theme
    bind=SUPER+SHIFT,w,spawn,wall-select

    bind=SUPER,Return,spawn,ghostty
    bind=SUPER+CTRL,Return,spawn,ghostty --class=floating
    bind=SUPER,Space,spawn,wofi -S drun -I -W 600 -H 400 -l center -p "Search apps..."

    bind=SUPER,Y,spawn,ghostty --class=floating -e yazi
    bind=SUPER,B,spawn,helium

    bind=SUPER,Left,focusdir,left
    bind=SUPER,Right,focusdir,right
    bind=SUPER,Up,focusdir,up
    bind=SUPER,Down,focusdir,down

    bind=SUPER+SHIFT,Up,exchange_client,up
    bind=SUPER+SHIFT,Down,exchange_client,down
    bind=SUPER+SHIFT,Left,exchange_client,left
    bind=SUPER+SHIFT,Right,exchange_client,right

    bind=SUPER+CTRL,Up,viewtoleft,0
    bind=SUPER+CTRL,Down,viewtoright,0
    bind=SUPER+CTRL+ALT,Up,tagtoleft,0
    bind=SUPER+CTRL+ALT,Down,tagtoright,0

    bind=SUPER,1,view,1
    bind=SUPER,2,view,2
    bind=SUPER,3,view,3
    bind=SUPER,4,view,4
    bind=SUPER,5,view,5
    bind=SUPER,6,view,6
    bind=SUPER,7,view,7
    bind=SUPER,8,view,8
    bind=SUPER,9,view,9

    bind=SUPER+SHIFT,1,tag,1
    bind=SUPER+SHIFT,2,tag,2
    bind=SUPER+SHIFT,3,tag,3
    bind=SUPER+SHIFT,4,tag,4
    bind=SUPER+SHIFT,5,tag,5
    bind=SUPER+SHIFT,6,tag,6
    bind=SUPER+SHIFT,7,tag,7
    bind=SUPER+SHIFT,8,tag,8
    bind=SUPER+SHIFT,9,tag,9

    bind=SUPER+CTRL,Left,focusmon,left
    bind=SUPER+CTRL,Right,focusmon,right
    bind=SUPER+SHIFT+CTRL,Left,tagmon,left
    bind=SUPER+SHIFT+CTRL,Right,tagmon,right

    bind=SUPER,equal,resizewin,5,0
    bind=SUPER,minus,resizewin,-5,0
    bind=SUPER+CTRL,equal,resizewin,0,5
    bind=SUPER+CTRL,minus,resizewin,0,-5

    bind=SUPER,W,togglefloating
    bind=ALT,Tab,toggleoverview,
    bind=SUPER,Tab,focusstack,next

    bind=ALT,f,togglefullscreen,
    bind=ALT+SHIFT,f,togglefakefullscreen,
    bind=ALT,a,togglemaximizescreen,

    bind=SUPER,I,minimized,
    bind=SUPER+SHIFT,I,restore_minimized
    bind=SUPER+SHIFT,o,toggleoverlay,
    bind=SUPER+SHIFT,g,toggleglobal,

    bind=ALT,z,toggle_scratchpad

    bind=SUPER+SHIFT,S,spawn,mango-screenshot

    bind=CTRL,space,switch_layout
    bind=CTRL+SHIFT,space,spawn,layout-picker

    bind=SUPER+ALT,f,set_proportion,1.0
    bind=ALT,space,switch_proportion_preset,
    bind=SUPER+SHIFT,c,scroller_stack,right
    bind=SUPER,c,scroller_stack,left

    bind=ALT+SHIFT,X,incgaps,1
    bind=ALT+SHIFT,Z,incgaps,-1
    bind=ALT+SHIFT,R,togglegaps

    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize

    gesturebind=none,up,4,viewtoright,0
    gesturebind=none,down,4,viewtoleft,0

    gesturebind=none,left,3,focusdir,left
    gesturebind=none,right,3,focusdir,right
    gesturebind=none,up,3,focusdir,up
    gesturebind=none,down,3,focusdir,down
  '';
}

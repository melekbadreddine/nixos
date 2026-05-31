{config, ...}: {
  home.file.".config/mango/config.conf".text = ''
    # MangoWC Configuration

    # Appearance
    gappih=6
    gappiv=6
    gappoh=8
    gappov=8
    borderpx=2
    bordercolor=0x${config.lib.stylix.colors.base01}ff
    focuscolor=0x${config.lib.stylix.colors.base0D}ff

    # Window effect
    blur=1
    border_radius=10
    animations=1

    # Key Bindings
    # modifier + key, action, argument
    bind=SUPER,Return,spawn,ghostty
    bind=SUPER,b,spawn,helium
    bind=SUPER,z,spawn,zen
    bind=SUPER,a,spawn,antigravity
    bind=SUPER,w,spawn,warp-terminal
    bind=SUPER,e,spawn,nautilus
    bind=SUPER,Space,spawn,rofi -show drun
    bind=SUPER,q,killclient
    bind=SUPER,h,focusdir,left
    bind=SUPER,j,focusdir,down
    bind=SUPER,k,focusdir,up
    bind=SUPER,l,focusdir,right
    bind=SUPER+SHIFT,h,exchange_client,left
    bind=SUPER+SHIFT,j,exchange_client,down
    bind=SUPER+SHIFT,k,exchange_client,up
    bind=SUPER+SHIFT,l,exchange_client,right
    bind=SUPER,BackSpace,quit

    # Mouse Button Bindings
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize

    # Scroller Layout
    scroller_default_proportion=0.8
    scroller_focus_center=1
  '';
}

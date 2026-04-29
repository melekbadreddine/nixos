{ config, pkgs, ... }:

{
  # non-configured apps
  home.packages = with pkgs; [
    # file manager and compression
    lxqt.pcmanfm-qt
    lxqt.lxqt-archiver
    p7zip

    # desktop utilities
    featherpad
    qalculate-qt

    # media and system tools
    lxqt.pavucontrol-qt
    kdePackages.kolourpaint
    swayimg

    # screen capture
    wayshot

    # background and effects
    swaybg
    wlsunset
  ];

  # configured apps
  xdg.configFile = {
    featherpad = {
      target = "featherpad/fp.conf";
      force = true;
      text =
        with config.stylix;
        if (polarity == "dark") then
          "[text]" + "\n" + "darkColorScheme = true"
        else
          "[text]" + "\n" + "darkColorScheme = false";
    };
    pcmanfm-qt = {
      target = "pcmanfm-qt/default/settings.conf";
      force = true;
      text = ''
        [System]
        Archiver=lxqt-archiver
        Terminal=alacritty
      '';
    };
  };

  programs.swayimg = {
    enable = true;
    settings = {
      "keys.viewer" = {
        h = "prev_file";
        l = "next_file";
      };
      general = {
        mode = "viewer";
        size = "900,700";
      };
      list.all = "yes";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.SHELL = "${pkgs.fish}/bin/fish";
      selection.save_to_clipboard = true;
    };
  };
}

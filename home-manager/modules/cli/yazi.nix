{...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime";
        sort_reverse = true;
      };
      opener = {
        edit = [
          {
            exec = ''ghostty -e "fresh \"$@\""'';
            block = true;
            desc = "Edit with Fresh in Ghostty";
          }
        ];
        play = [
          {
            exec = ''ghostty -e "mpv \"$@\""'';
            block = false;
            desc = "Play with MPV in Ghostty";
          }
        ];
      };
    };
  };
}

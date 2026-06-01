{...}: {
  home.file.".config/mangowc/waybar/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}

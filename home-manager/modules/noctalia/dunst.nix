{config, ...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x30";
        origin = "top-right";
        transparency = 10;
        frame_color = "#${config.lib.stylix.colors.base0D}";
        font = "JetBrainsMono Nerd Font 10";
        corner_radius = 10;
      };
      urgency_low = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base05}";
      };
      urgency_normal = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base05}";
      };
      urgency_critical = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base08}";
      };
    };
  };
}

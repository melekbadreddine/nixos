{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#${config.lib.stylix.colors.base00}";
        bg-alt = mkLiteral "#${config.lib.stylix.colors.base01}";
        foreground = mkLiteral "#${config.lib.stylix.colors.base05}";
        accent = mkLiteral "#${config.lib.stylix.colors.base0D}";
      };
      "window" = {
        width = mkLiteral "750px";
        border-radius = mkLiteral "20px";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
      };
      "mainbox" = {
        children = map mkLiteral ["inputbar" "listview"];
      };
      "inputbar" = {
        padding = mkLiteral "12px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@foreground";
        children = map mkLiteral ["prompt" "entry"];
      };
      "listview" = {
        lines = 10;
        columns = 1;
      };
      "element" = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "10px";
      };
      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg";
      };
    };
  };
}

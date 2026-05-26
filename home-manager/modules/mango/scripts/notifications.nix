{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    settings = {
      background-color = "#${config.lib.stylix.colors.base00}dd";
      text-color = "#${config.lib.stylix.colors.base05}";
      border-color = "#${config.lib.stylix.colors.base0D}";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
      font = "DepartureMono Nerd Font 10";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "mango-notifications" ''
      COUNT=$(${pkgs.mako}/bin/makoctl list 2>/dev/null | ${pkgs.jq}/bin/jq -r '.data[0] | length' 2>/dev/null)
      if [ "$COUNT" = "null" ] || [ -z "$COUNT" ]; then COUNT=0; fi
      if [ "$COUNT" -gt 0 ]; then
        echo "{\"text\": \" $COUNT\", \"tooltip\": \"$COUNT unread notifications\", \"class\": \"has-notifications\"}"
      else
        echo "{\"text\": \"\", \"tooltip\": \"No unread notifications\", \"class\": \"no-notifications\"}"
      fi
    '')
  ];
}

{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "mango-screenshot" ''
      FILE=~/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png
      mkdir -p ~/Pictures
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$FILE" && \
      ${pkgs.wl-clipboard}/bin/wl-copy < "$FILE" && \
      ${pkgs.libnotify}/bin/notify-send "Screenshot saved & copied" "$FILE"
    '')
  ];
}

{
  vars,
  lib,
  ...
}: {
  dconf.settings = lib.mkIf vars.cosmicEnable {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      enable-animations = true;
    };
  };

  # COSMIC Desktop Custom Keybindings
  home.file.".config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom" = lib.mkIf vars.cosmicEnable {
    text = ''
      (
          custom_shortcuts: [
              (
                  name: "Helium",
                  description: "Open Helium Browser",
                  bindings: ["<Super>b"],
                  command: "helium",
              ),
              (
                  name: "Cosmic Files",
                  description: "Open File Manager",
                  bindings: ["<Super>e"],
                  command: "cosmic-files",
              ),
              (
                  name: "Ghostty",
                  description: "Open Ghostty Terminal",
                  bindings: ["<Super>Return"],
                  command: "ghostty",
              ),
              (
                  name: "Zen Browser",
                  description: "Open Zen Browser",
                  bindings: ["<Super>z"],
                  command: "zen",
              ),
              (
                  name: "Antigravity",
                  description: "Open Antigravity",
                  bindings: ["<Super>a"],
                  command: "antigravity",
              ),
              (
                  name: "Warp",
                  description: "Open Warp Terminal",
                  bindings: ["<Super>w"],
                  command: "warp-terminal",
              ),
              (
                  name: "Log Out",
                  description: "Log out of session",
                  bindings: ["<Super>BackSpace"],
                  command: "cosmic-session-quit --logout",
              ),
          ]
      )
    '';
  };
}

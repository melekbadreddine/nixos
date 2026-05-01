{ pkgs, helium, ... }: let
  chromiumUpdateUrl = "https://clients2.google.com/service/update2/crx";
  heliumExtensions = [
    "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;${chromiumUpdateUrl}" # Privacy Badger
    "mnjggcdmjocbbbhaepdhchncahnbgone;${chromiumUpdateUrl}" # SponsorBlock for YouTube
    "cnjifjpddelmedmihgijeibhnjfabmlf;${chromiumUpdateUrl}" # Obsidian Web Clipper
    "bpoadfkcbjbfhfodiogcnhhhpibjhbnh;${chromiumUpdateUrl}" # Immersive Translate
    "ahmpjcflkgiildlgicmcieglgoilbfdp;${chromiumUpdateUrl}" # Free Download Manager
    "gojogohjgpelafgaeejgelmplndppifh;${chromiumUpdateUrl}" # Unlimited Email Tracker by Snov.io
  ];
in {
  home.packages = [ 
    helium.packages.${pkgs.stdenv.hostPlatform.system}.default 
  ];

  # Chromium-compatible policy file consumed by Helium.
  xdg.configFile."helium/policies/managed/extensions.json".text = builtins.toJSON {
    ExtensionInstallForcelist = heliumExtensions;
  };
}

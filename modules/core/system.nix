{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Chromium policy bridge for Chromium-based browsers (including Helium).
  programs.chromium = {
    enable = true;
    extensions = [
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;https://clients2.google.com/service/update2/crx" # Privacy Badger
      "mnjggcdmjocbbbhaepdhchncahnbgone;https://clients2.google.com/service/update2/crx" # SponsorBlock for YouTube
      "cnjifjpddelmedmihgijeibhnjfabmlf;https://clients2.google.com/service/update2/crx" # Obsidian Web Clipper
      "bpoadfkcbjbfhfodiogcnhhhpibjhbnh;https://clients2.google.com/service/update2/crx" # Immersive Translate
      "ahmpjcflkgiildlgicmcieglgoilbfdp;https://clients2.google.com/service/update2/crx" # Free Download Manager
      "gojogohjgpelafgaeejgelmplndppifh;https://clients2.google.com/service/update2/crx" # Unlimited Email Tracker by Snov.io
    ];
  };

  environment.systemPackages = with pkgs; [
    # Windows compatibility layer
    wineWow64Packages.stable
    winetricks
  ];
}

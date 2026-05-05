{pkgs, ...}: {
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

  # System-wide Helium policy
  environment.etc."helium/policies/managed/extensions.json".text = builtins.toJSON {
    ExtensionInstallForcelist = [
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;https://clients2.google.com/service/update2/crx"
      "mnjggcdmjocbbbhaepdhchncahnbgone;https://clients2.google.com/service/update2/crx"
      "cnjifjpddelmedmihgijeibhnjfabmlf;https://clients2.google.com/service/update2/crx"
      "bpoadfkcbjbfhfodiogcnhhhpibjhbnh;https://clients2.google.com/service/update2/crx"
      "ahmpjcflkgiildlgicmcieglgoilbfdp;https://clients2.google.com/service/update2/crx"
      "gojogohjgpelafgaeejgelmplndppifh;https://clients2.google.com/service/update2/crx"
    ];
  };

  environment.systemPackages = with pkgs; [
    # Windows compatibility layer
    wineWow64Packages.stable
    winetricks
  ];
}

{ ... }:

{
  programs.plasma = {
    enable = true;

    panels = [
      {
        location = "top";
        height = 32;
        floating = true;
        alignment = "center";
        lengthMode = "custom";
        minLength = 100; # This makes it span but we can adjust
        maxLength = 100;
        
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake";
              };
            };
          }
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # Shortcut configurations or other workspace settings can go here
    workspace = {
      clickItemTo = "select"; # I prefer this, change if you like open
      lookAndFeel = "org.kde.breeze.desktop";
    };
  };
}

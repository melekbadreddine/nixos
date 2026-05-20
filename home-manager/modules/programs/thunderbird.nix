{...}: {
  programs.thunderbird = {
    enable = true;
    profiles.melek = {
      isDefault = true;
    };
  };
}

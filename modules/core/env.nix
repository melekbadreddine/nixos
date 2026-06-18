{...}: {
  environment.sessionVariables = {
    # System-wide Wayland keyboard layout specifications
    XKB_DEFAULT_LAYOUT = "fr";
    XKB_DEFAULT_VARIANT = "oss";
    XKB_DEFAULT_MODEL = "pc105";

    # Consistent XDG Fallbacks
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}

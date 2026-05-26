#!/usr/bin/env bash
# Generate a themed Fedora logo SVG for Waybar
# Reads the current Mango theme to determine the accent color.

# ─── Determine active theme ───
MANGO_DIR="${HOME}/.config/mango"
CURRENT_THEME_FILE="${MANGO_DIR}/.theme"

THEME_COLOR="#b8bb26"  # fallback (Gruvbox green)
ACTIVE_THEME=""

if [[ -f "$CURRENT_THEME_FILE" ]]; then
    ACTIVE_THEME=$(cat "$CURRENT_THEME_FILE" | tr -d '[:space:]')
    THEME_CONF="${MANGO_DIR}/themes/${ACTIVE_THEME}/theme.conf"

    if [[ -f "$THEME_CONF" ]]; then
        # Source only the ACCENT variable from the theme config
        # Use a subshell to avoid polluting the current shell environment
        ACCENT=$(
            # shellcheck source=/dev/null
            source "$THEME_CONF" >/dev/null 2>&1 && printf '%s' "$ACCENT"
        )
        if [[ -n "$ACCENT" ]]; then
            THEME_COLOR="$ACCENT"
        fi
    fi
fi

OUTPUT="/tmp/fedora-logo-themed.svg"

# Build sed command based on theme
if [[ "$ACTIVE_THEME" == "monochrome" ]]; then
    # Monochrome: white F on black background
    SED_CMD="s/#51a2da/#000000/g"
else
    # All other themes: black F on accent-colored background
    # IMPORTANT: Replace white/fa-white fills FIRST, then the blue background LAST.
    # Otherwise the newly-white background would also get turned black.
    SED_CMD="s/#ffffff/#000000/g; s/#fafafa/#000000/g; s/#51a2da/${THEME_COLOR}/g"
fi

sed "$SED_CMD" /usr/share/pixmaps/fedora-logo-sprite.svg > "$OUTPUT"

echo "$OUTPUT"

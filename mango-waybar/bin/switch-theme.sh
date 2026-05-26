#!/bin/bash
# =============================================================
# switch-theme.sh - Theme picker with preview images
# SUPER+SHIFT+T
# Usage:
#   switch-theme.sh          - Show theme picker
#   switch-theme.sh --apply  - Apply current theme (for startup)
# =============================================================

set -euo pipefail

MANGO_DIR="$HOME/.config/mango"
THEMES_DIR="$MANGO_DIR/themes"
TEMPLATES_DIR="$MANGO_DIR/templates"
BARS_DIR="$MANGO_DIR/bars"
WOFI_DIR="$MANGO_DIR/wofi"
CURRENT_THEME_FILE="$MANGO_DIR/.theme"

# Read current theme
current_theme=""
[ -f "$CURRENT_THEME_FILE" ] && current_theme=$(cat "$CURRENT_THEME_FILE")

# ─── Apply mode: just apply current theme without picker ───
if [ "${1:-}" = "--apply" ]; then
    if [ -z "$current_theme" ] || [ ! -d "$THEMES_DIR/$current_theme" ]; then
        echo "No current theme found, defaulting to gruvbox"
        current_theme="gruvbox"
    fi
    selected="$current_theme"
else
    # ─── Picker mode: show wofi theme selector ───

# List themes with preview images
selected_index=-1
index=0
selected=""
for theme_dir in "$THEMES_DIR"/*/; do
    [ -d "$theme_dir" ] || continue
    theme_name=$(basename "$theme_dir")

    # Find preview image
    preview_file="$theme_dir/preview.png"
    [ ! -f "$preview_file" ] && preview_file="$theme_dir/preview.jpg"
    [ ! -f "$preview_file" ] && preview_file=""

    # Track current theme index
    [ "$theme_name" = "$current_theme" ] && selected_index=$index
    index=$((index + 1))
done

# Build wofi menu entries
menu_entries=""
for theme_dir in "$THEMES_DIR"/*/; do
    [ -d "$theme_dir" ] || continue
    theme_name=$(basename "$theme_dir")

    # Find preview image
    preview_file="$theme_dir/preview.png"
    [ ! -f "$preview_file" ] && preview_file="$theme_dir/preview.jpg"
    [ ! -f "$preview_file" ] && preview_file=""

    if [ -n "$preview_file" ]; then
        menu_entries="${menu_entries}${theme_name}\000icon\037${preview_file}\n"
    else
        menu_entries="${menu_entries}${theme_name}\n"
    fi
done

# Show wofi menu
selected=$(echo -e "$menu_entries" | wofi \
    -d \
    -p "Themes" \
    -W 500 \
    -H 400 \
    -l center \
    -s "$WOFI_DIR/style.css" \
    -c "$WOFI_DIR/config" \
    ${selected_index:+--define "initial-selection=$selected_index"} \
    2>/dev/null || true)

[ -z "$selected" ] && exit 0

fi  # End of picker/apply mode selection

# Source the selected theme
THEME_DIR="$THEMES_DIR/$selected"
THEME_CONF="$THEME_DIR/theme.conf"

if [ ! -f "$THEME_CONF" ]; then
    notify-send "Theme Error" "theme.conf not found for: $selected"
    exit 1
fi

# Source theme configuration
source "$THEME_CONF"

# Write current theme
echo "$selected" > "$CURRENT_THEME_FILE"

# ─── Helper: Convert hex to RGB ───
hex_to_rgb() {
    local hex="${1#\#}"
    echo "$((16#${hex:0:2})),$((16#${hex:2:2})),$((16#${hex:4:2}))"
}

# Pre-compute RGB values
BG_RGB=$(hex_to_rgb "$BG")
FG_RGB=$(hex_to_rgb "$FG")
PRIMARY_RGB=$(hex_to_rgb "$PRIMARY")
SECONDARY_RGB=$(hex_to_rgb "$SECONDARY")
ACCENT_RGB=$(hex_to_rgb "$ACCENT")
ERROR_RGB=$(hex_to_rgb "$ERROR")
SURFACE_RGB=$(hex_to_rgb "$SURFACE")
OUTLINE_RGB=$(hex_to_rgb "$OUTLINE")
RED_RGB=$(hex_to_rgb "$RED")
ORANGE_RGB=$(hex_to_rgb "${ORANGE:-#fe8019}")
WARNING_RGB=$(hex_to_rgb "${WARNING:-#83a598}")
SUCCESS_RGB=$(hex_to_rgb "${SUCCESS:-#8ec07c}")

# ─── Helper: Apply template ───
apply_template() {
    local template="$1"
    local output="$2"

    if [ ! -f "$template" ]; then
        echo "Warning: Template not found: $template"
        return 1
    fi

    sed \
        -e "s|__BG__|${BG}|g" \
        -e "s|__FG__|${FG}|g" \
        -e "s|__PRIMARY__|${PRIMARY}|g" \
        -e "s|__SECONDARY__|${SECONDARY}|g" \
        -e "s|__TERTIARY__|${TERTIARY}|g" \
        -e "s|__ACCENT__|${ACCENT}|g" \
        -e "s|__ERROR__|${ERROR}|g" \
        -e "s|__SURFACE__|${SURFACE}|g" \
        -e "s|__OUTLINE__|${OUTLINE}|g" \
        -e "s|__SHADOW__|${SHADOW}|g" \
        -e "s|__WARNING__|${WARNING}|g" \
        -e "s|__SUCCESS__|${SUCCESS}|g" \
        -e "s|__HOVER__|${HOVER}|g" \
        -e "s|__BG_ALT__|${BG_ALT}|g" \
        -e "s|__ORANGE__|${ORANGE:-#fe8019}|g" \
        -e "s|__DIM__|${DIM:-#665c54}|g" \
        -e "s|__BLACK__|${BLACK}|g" \
        -e "s|__RED__|${RED}|g" \
        -e "s|__GREEN__|${GREEN}|g" \
        -e "s|__YELLOW__|${YELLOW}|g" \
        -e "s|__BLUE__|${BLUE}|g" \
        -e "s|__MAGENTA__|${MAGENTA}|g" \
        -e "s|__CYAN__|${CYAN}|g" \
        -e "s|__WHITE__|${WHITE}|g" \
        -e "s|__BLACKB__|${BLACKB}|g" \
        -e "s|__REDB__|${REDB}|g" \
        -e "s|__GREENB__|${GREENB}|g" \
        -e "s|__YELLOWB__|${YELLOWB}|g" \
        -e "s|__BLUEB__|${BLUEB}|g" \
        -e "s|__MAGENTAB__|${MAGENTAB}|g" \
        -e "s|__CYANB__|${CYANB}|g" \
        -e "s|__WHITEB__|${WHITEB}|g" \
        -e "s|__BG_RGB__|${BG_RGB}|g" \
        -e "s|__FG_RGB__|${FG_RGB}|g" \
        -e "s|__PRIMARY_RGB__|${PRIMARY_RGB}|g" \
        -e "s|__SECONDARY_RGB__|${SECONDARY_RGB}|g" \
        -e "s|__ACCENT_RGB__|${ACCENT_RGB}|g" \
        -e "s|__ERROR_RGB__|${ERROR_RGB}|g" \
        -e "s|__SURFACE_RGB__|${SURFACE_RGB}|g" \
        -e "s|__OUTLINE_RGB__|${OUTLINE_RGB}|g" \
        -e "s|__RED_RGB__|${RED_RGB}|g" \
        -e "s|__ORANGE_RGB__|${ORANGE_RGB}|g" \
        -e "s|__WARNING_RGB__|${WARNING_RGB}|g" \
        -e "s|__SUCCESS_RGB__|${SUCCESS_RGB}|g" \
        -e "s|__GTK_THEME__|${GTK_THEME}|g" \
        -e "s|__ICON_THEME__|${ICON_THEME}|g" \
        -e "s|__CURSOR_THEME__|${CURSOR_THEME}|g" \
        -e "s|__CURSOR_SIZE__|${CURSOR_SIZE}|g" \
        -e "s|__GTK_FONT__|${GTK_FONT}|g" \
        -e "s|__WARNING_BG__|${WARNING_BG:-#294d3f}|g" \
        -e "s|__WARNING_FG__|${WARNING_FG:-#e1eae6}|g" \
        -e "s|__SUCCESS_BG__|${SUCCESS_BG:-#356722}|g" \
        -e "s|__SUCCESS_FG__|${SUCCESS_FG:-#e1eedd}|g" \
        "$template" > "$output"
}

# ─── 1. Apply Bar (waybar) ───
BAR_NAME="${BAR_NAME:-full}"
BAR_DIR="$BARS_DIR/$BAR_NAME"
mkdir -p "$HOME/.config/waybar"

if [ -d "$BAR_DIR" ]; then
    # Generate waybar config dynamically based on connected outputs
    if [ -f "$MANGO_DIR/bin/generate-waybar-config.py" ]; then
        python3 "$MANGO_DIR/bin/generate-waybar-config.py" > "$HOME/.config/waybar/config.jsonc"
    elif [ -f "$BAR_DIR/config.jsonc" ]; then
        # Fallback to static config
        cp "$BAR_DIR/config.jsonc" "$HOME/.config/waybar/config.jsonc"
    fi

    # Apply bar style template
    [ -f "$BAR_DIR/style.css.template" ] && apply_template "$BAR_DIR/style.css.template" "$HOME/.config/waybar/style.css"
fi

# Also copy theme-specific waybar overrides (if they exist)
if [ -d "$THEME_DIR/waybar" ]; then
    [ -f "$THEME_DIR/waybar/config.jsonc" ] && cp "$THEME_DIR/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
    [ -f "$THEME_DIR/waybar/style.css" ] && cp "$THEME_DIR/waybar/style.css" "$HOME/.config/waybar/style.css"
fi

# ─── 2. Apply Wofi ───
mkdir -p "$WOFI_DIR" "$HOME/.config/wofi"
apply_template "$TEMPLATES_DIR/wofi-style.css.template" "$WOFI_DIR/style.css"
apply_template "$TEMPLATES_DIR/wofi-style.css.template" "$HOME/.config/wofi/style.css"
apply_template "$TEMPLATES_DIR/wofi-wallpaper.css.template" "$WOFI_DIR/wallpaper.css"

# ─── 2b. Apply Logout Menu Colors ───
mkdir -p "$HOME/.config/waybar/scripts"
apply_template "$TEMPLATES_DIR/logout-menu-colors.py.template" "$HOME/.config/waybar/scripts/logout-menu-colors.py"

# ─── 2c. Copy Fedora Logo Script ───
cp "$MANGO_DIR/waybar/scripts/fedora-logo-themed.sh" "$HOME/.config/waybar/scripts/fedora-logo-themed.sh"

# ─── 3. Apply Mako ───
mkdir -p "$HOME/.config/mako"
apply_template "$TEMPLATES_DIR/mako-config.template" "$HOME/.config/mako/config"

# ─── 4. Apply GTK Settings ───
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
for gtk_dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
    [ -f "$gtk_dir/settings.ini" ] || continue
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/" "$gtk_dir/settings.ini"
    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$ICON_THEME/" "$gtk_dir/settings.ini"
    sed -i "s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$CURSOR_THEME/" "$gtk_dir/settings.ini"
    sed -i "s/^gtk-font-name=.*/gtk-font-name=$GTK_FONT/" "$gtk_dir/settings.ini"
done

# Update gsettings for live theme switching (GTK3/4, libadwaita, wofi)
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME" 2>/dev/null || true

# Update icon cache so GTK apps pick up new icons immediately
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/$ICON_THEME" 2>/dev/null || true
gtk-update-icon-cache -f -t "/usr/share/icons/$ICON_THEME" 2>/dev/null || true

# ─── 4b. Update Fastfetch Config & Logo Color ───
FASTFETCH_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_DIR"

# Generate fastfetch config from template
apply_template "$TEMPLATES_DIR/fastfetch-config.jsonc.template" "$FASTFETCH_DIR/config.jsonc"

if [ -n "${PRIMARY:-}" ]; then
    # Convert hex to ANSI color code
    PRIMARY_HEX="${PRIMARY#\#}"
    R=$((16#${PRIMARY_HEX:0:2}))
    G=$((16#${PRIMARY_HEX:2:2}))
    B=$((16#${PRIMARY_HEX:4:2}))
    # Generate fastfetch logo with theme primary color using truecolor ANSI
    cat > "$FASTFETCH_DIR/ascii.txt" << 'LOGOEOF'
             ::::::::::::             
        :::::::::::::::::::::        
      ::::::::::::::::::::::::::      
    :::::::::::::::::::::::::::::    
   ::::::::::::::::       ::::::::   
  :::::::::::::::   ::::   ::::::::  
 ::::::::::::::::  ::::::   :::::::: 
 ::::::::::::::::  ::::::: ::::::::::
:::::::::::::::::  ::::::::::::::::::
::::::::::::     ::      ::::::::::::::
::::::::   ::::::  ::::::::::::::::::
:::::::   :::::::  ::::::::::::::::: 
:::::::   :::::::  ::::::::::::::::  
::::::::   :::::   ::::::::::::::::   
:::::::::        ::::::::::::::::    
::::::::::::::::::::::::::::::::      
:::::::::::::::::::::::::::::        
  :::::::::::::::::::::::
LOGOEOF
    # Apply ANSI truecolor to the logo
    sed -i "s/\(.*\)/\x1b[38;2;${R};${G};${B}m\1\x1b[0m/" "$FASTFETCH_DIR/ascii.txt"
fi

# ─── 5. Apply Kitty Theme ───
mkdir -p "$HOME/.config/kitty"
# Copy theme-specific kitty config (if it exists)
if [ -f "$THEME_DIR/kitty/theme.conf" ]; then
    cp "$THEME_DIR/kitty/theme.conf" "$HOME/.config/kitty/current-theme.conf"
else
    # Generate from template
    apply_template "$TEMPLATES_DIR/kitty-theme.conf.template" "$HOME/.config/kitty/current-theme.conf"
fi

# Hot-reload kitty (SIGUSR1)
pkill -SIGUSR1 kitty 2>/dev/null || true

# ─── 5b. Apply htop ───
mkdir -p "$HOME/.config/htop"
apply_template "$TEMPLATES_DIR/htoprc.template" "$HOME/.config/htop/htoprc"

# ─── 5c. Apply Yazi Theme ───
mkdir -p "$HOME/.config/yazi/flavors/mango.yazi"
apply_template "$TEMPLATES_DIR/yazi-flavor.toml.template" "$HOME/.config/yazi/flavors/mango.yazi/flavor.toml"
cat > "$HOME/.config/yazi/theme.toml" <<'YAziEOF'
[flavor]
dark  = "mango"
light = "mango"
YAziEOF

# ─── 6. Apply Qt5ct/Qt6ct Colors ───
mkdir -p "$HOME/.config/qt5ct/colors" "$HOME/.config/qt6ct/colors"
apply_template "$TEMPLATES_DIR/qt-colors.conf.template" "$HOME/.config/qt5ct/colors/gruvbox.conf"
apply_template "$TEMPLATES_DIR/qt-colors.conf.template" "$HOME/.config/qt6ct/colors/gruvbox.conf"

# Update qt5ct/qt6ct config to use the new color scheme
sed -i "s|^color_scheme_path=.*|color_scheme_path=$HOME/.config/qt5ct/colors/gruvbox.conf|" "$HOME/.config/qt5ct/qt5ct.conf" 2>/dev/null || true
sed -i "s|^color_scheme_path=.*|color_scheme_path=$HOME/.config/qt6ct/colors/gruvbox.conf|" "$HOME/.config/qt6ct/qt6ct.conf" 2>/dev/null || true
sed -i "s|^icon_theme=.*|icon_theme=$ICON_THEME|" "$HOME/.config/qt5ct/qt5ct.conf" 2>/dev/null || true
sed -i "s|^icon_theme=.*|icon_theme=$ICON_THEME|" "$HOME/.config/qt6ct/qt6ct.conf" 2>/dev/null || true

# ─── 7. Apply Zed Editor Theme ───
if [ -n "${ZED_THEME:-}" ] && [ -f "$HOME/.config/zed/settings.json" ]; then
    python3 -c "
import re

with open('$HOME/.config/zed/settings.json', 'r') as f:
    content = f.read()

theme_name = '${ZED_THEME}'

# Try to update \"dark\" field in theme object first
new_content = re.sub(
    r'(\"theme\"\s*:\s*\{[\\s\\S]*?\"dark\"\s*:\s*\")([^\"]*)(\")',
    r'\1' + theme_name + r'\3',
    content
)

# If no change, try simple string format
if new_content == content:
    new_content = re.sub(
        r'(\"theme\"\s*:\s*\")([^\"]*)(\")',
        r'\1' + theme_name + r'\3',
        content
    )

with open('$HOME/.config/zed/settings.json', 'w') as f:
    f.write(new_content)
" 2>/dev/null || true
fi

# ─── 8. Apply Mango WM Colors ───
MANGO_COLORS_FILE="$HOME/.config/mango/theme-colors.conf"

# Helper: convert #RRGGBB → 0xRRGGBBff
hex_to_mango() {
    local hex="${1#\#}"
    echo "0x${hex}ff"
}

if [ -n "${MANGO_BORDER_FOCUSED:-}" ]; then
    cat > "$MANGO_COLORS_FILE" <<EOF
# Auto-generated Mango theme colors
# Theme: ${THEME_NAME:-$selected}

shadowscolor = $(hex_to_mango "${BG}")
rootcolor = $(hex_to_mango "${BG}")
bordercolor = $(hex_to_mango "${SURFACE}")
focuscolor = $(hex_to_mango "${MANGO_BORDER_FOCUSED}")
maximizescreencolor = $(hex_to_mango "${SECONDARY}")
urgentcolor = $(hex_to_mango "${ERROR}")
scratchpadcolor = $(hex_to_mango "${TERTIARY}")
globalcolor = $(hex_to_mango "${WARNING}")
overlaycolor = $(hex_to_mango "${SUCCESS}")
EOF

    # Hot-reload mango config
    mmsg -d reload_config 2>/dev/null || true
fi

# ─── 9. Generate Themed Fedora Logo ───
mkdir -p "$HOME/.cache/waybar"
FEDORA_LOGO_CACHE="$HOME/.cache/waybar/fedora-logo.png"
FEDORA_LOGO_SOURCE="/usr/share/icons/hicolor/256x256/apps/fedora-logo-icon.png"

if [ -f "$FEDORA_LOGO_SOURCE" ] && [ -n "${ACCENT:-}" ]; then
    ACCENT_RGB="${ACCENT#\#}"
    convert "$FEDORA_LOGO_SOURCE" \
        -fill "#${ACCENT_RGB}" \
        -colorize 100% \
        -resize 18x18 \
        "$FEDORA_LOGO_CACHE" 2>/dev/null || true
fi

# ─── 10. Set Wallpaper ───
WALL_DIR="$THEME_DIR/wallpapers"
if [ -n "${WALLPAPER_DEFAULT:-}" ] && [ -f "$WALL_DIR/$WALLPAPER_DEFAULT" ]; then
    mkdir -p ~/.cache/awww
    # Start awww-daemon if not running
    pgrep -x "awww-daemon" > /dev/null || awww-daemon &>/dev/null &
    sleep 0.5
    awww img "$WALL_DIR/$WALLPAPER_DEFAULT" 2>/dev/null || true
fi

# ─── 10b. Restart Crystal Dock ───
killall crystal-dock 2>/dev/null || true
sleep 0.2
crystal-dock &

# ─── 11. Restart Waybar ───
killall waybar 2>/dev/null || true
sleep 0.5
waybar &

# ─── 12. Restart Mako ───
killall mako 2>/dev/null || true
sleep 0.5
mako &

# ─── 13. Notification ───
notify-send "Theme Switched" "Now using: ${THEME_NAME:-$selected}" -i preferences-desktop-theme

echo "Theme applied: $selected"

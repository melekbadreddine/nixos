#!/bin/bash
# Toggle gappoh between 10 and 450 while keeping structs at 450

CONFIG_FILE="$HOME/.config/mango/config.conf"
TAG_FILE="$HOME/.config/mango/tag.conf"
STATE_FILE="$HOME/.config/mango/.recording_mode"

# Always keep structs at 450
STRUCTS=450

# Toggle gappoh between 10 and 450
if [ -f "$STATE_FILE" ]; then
    NEW_GAPPOH=10
    MODE="Normal"
    rm "$STATE_FILE"
else
    NEW_GAPPOH=450
    MODE="Recording (16:9)"
    touch "$STATE_FILE"
fi

# Update scroller_structs (always 450)
sed -i "s/^scroller_structs=.*/scroller_structs=$STRUCTS/" "$CONFIG_FILE"

# Update gappoh (outer horizontal gaps for tile/center_tile layouts)
sed -i "s/^gappoh=.*/gappoh=$NEW_GAPPOH/" "$CONFIG_FILE"

# Toggle HDMI-A-1 tag 1 layout
if [ "$MODE" = "Recording (16:9)" ]; then
    sed -i "s/^tagrule=id:1,monitor_name:\^HDMI-A-1\$,layout_name:.*/tagrule=id:1,monitor_name:^HDMI-A-1\$,layout_name:vertical_grid/" "$TAG_FILE"
else
    sed -i "s/^tagrule=id:1,monitor_name:\^HDMI-A-1\$,layout_name:.*/tagrule=id:1,monitor_name:^HDMI-A-1\$,layout_name:vertical_tile/" "$TAG_FILE"
fi

# Reload mango configuration
mmsg -d reload_config

# Send notification
notify-send "Mode: $MODE" "Structs: ${STRUCTS}px | Gaps: ${NEW_GAPPOH}px"
